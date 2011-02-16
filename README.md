Komando
=======

Commands are used in many applications, especially GUIs. Komando is an implementation of the [Command pattern][1],
especially suited to Rails applications. Commands are provided the information they need, then told to run. Commands
can be marked best effort, or mandatory. Commands can refer to other commands, and ask that the sub-commands be
mandatory or best effort.

Most web applications have a lot of before and after hooks that occur when working with objects: sending a
welcome email on registration, incrementing or decrementing counter caches, trigger validation on remote web
services. When implemented using callbacks, all these occur without the developer knowing about them. A
simple change in one area of the code can have a huge impact somewhere else. Inspiration for this came from
[Unintented Consequences: The Pitfalls of ActiveRecord Callbacks][2] and
[Crazy, Heretical, and Awesome: The Way I Write Rails Apps][3].


Examples
--------

    require "komando/command"
    require "komando/active_record"

    class AdUpdateCommand
      include Komando::Command

      def initialize(*args)
        @initiated_at = Time.now.utc

        # If you must override #initialize, NEVER forget to call super
        super

        # Forgetting to call super will result in NoMethodError and such
        # being raised from your code.
      end

      # Lets exceptions through -- nothing is rescued -- callers will have
      # to handle exceptions themselves. The command's success/failure state
      # is determined by the fact that no exceptions are raised. The block's
      # return value is ignored.
      #
      # All #mandatory_steps are run within a single database transaction.
      mandatory_steps do
        @ad.update_attributes!(@params)
        @ad.campaign.update_attribute(:active_ad_units_count, @ad.campaign.ad_units.active.count)
      end

      # The #transaction block can be used to root your transaction differently.
      # The default #transaction block simply yields - no transactions will be
      # processed. The komando-active_record gem will root your transactions
      # against ActiveRecord::Base#transaction.
      #
      # This method is important if you have more than one database connection,
      # where each model might open transactions against different databases.
      transaction do
        AdUnit.transaction do
          yield
        end
      end
    end

    class PlacementEventLoggerCommand
      include Komando::Command

      mandatory_steps do
        Event.create!(:event_type => "placement:created", :actor => @actor, :subject => @subject)
      end
    end

    class PlacementCreationCommand
      include Komando::Command

      mandatory_steps do
        @placement = Placement.create!(@params)

        @placement.campaign.increment!(:active_placements_count, 1)    if @placement.active?
        @placement.campaign.increment!(:scheduled_placements_count, 1) if @placement.scheduled?
      end

      # Call #best_effort_step multiple times to declare each individual step
      # that will be attempted. If a block fails, logging will ensue, and
      # other blocks will be attempted.
      #
      # #best_effort_step can document what it's supposed to do, enabling
      # better logging. Either pass a String or Symbol, the latter of which will
      # be #humanized.
      best_effort_step(:event_generation) do

        # Note the availability of a class-level method named #run, which simply does the obvious
        # instantiation and call the instance-level #run.
        PlacementEventLoggerCommand.run(:actor => @placement.created_by, :subject => @placement)

      end
    end

    # Usage from Rails
    class AdsController < ApplicationController

      def update
        @ad = Ad.find(params[:id])

        # Commands accept any number of parameters, as a Hash. Parameters are translated
        # to instance variables within the Command object itself.
        command = AdUpdateCommand.new(:ad     => @ad,
                                      :params => params[:ad])
        if command.run then
          flash[:notice] = "Ad updated"
          redirect_to @ad
        else
          flash.new[:error] = "Ad failed to save"
          render :action => :edit
        end
      end

    end


Notes on Patches/Pull Requests
-----------------------------

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.


Compatibility
-------------

Komando is known to pass it's specifications on the following Ruby implementations (rvm version specifiers):

* jruby-1.5.6 [ x86_64-java ]
* ree-1.8.7-2011.01 [ x86_64 ]
* ruby-1.8.7-p330 [ x86_64 ]
* ruby-1.9.2-p136 [ x86_64 ]


Copyright
---------

Copyright (c) 2010 François Beausoleil. See LICENSE for details.

  [1]: http://en.wikipedia.org/wiki/Command_pattern
  [2]: http://blog.teksol.info/2010/09/28/unintented-consequences-the-pitfalls-of-activerecord-callbacks.html
  [3]: http://jamesgolick.com/2010/3/14/crazy-heretical-and-awesome-the-way-i-write-rails-apps.html
