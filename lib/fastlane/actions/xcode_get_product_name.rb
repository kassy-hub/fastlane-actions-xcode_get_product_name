require "fastlane/actions/xcode_get_product_name/version"
require "gym"
require "fastlane_core"

module FastlaneCore
  # Represents an Xcode project
  class Project
    def build_settings(key: nil, optional: true)
      unless @build_settings
        # We also need to pass the workspace and scheme to this command
        command = "xcrun xcodebuild -showBuildSettings #{xcodebuild_parameters.join(' ')}"
        command += " -configuration '#{options[:configuration]}'" if options[:configuration]
        @build_settings = Helper.backticks(command, print: false)
      end

      begin
        result = @build_settings.split("\n").find { |c| c.split(" = ").first.strip == key }
        return result.split(" = ").last
      rescue => ex
        return nil if optional # an optional value, we really don't care if something goes wrong

        Helper.log.error caller.join("\n\t")
        Helper.log.error "Could not fetch #{key} from project file: #{ex}"
      end

      nil
    end
  end
end

module Fastlane
  module Actions
    module SharedValues
      GET_PRODUCT_NAME_CUSTOM_VALUE = :GET_PRODUCT_NAME_CUSTOM_VALUE
    end

    # To share this integration with the other fastlane users:
    # - Fork https://github.com/KrauseFx/fastlane
    # - Clone the forked repository
    # - Move this integration into lib/fastlane/actions
    # - Commit, push and submit the pull request

    class XcodeGetProductNameAction < Action
      def self.run(params)
        # fastlane will take care of reading in the parameter and fetching the environment variable:
        # Helper.log.info "Parameter API Token: #{params[:api_token]}"

        if params[:target]
            params[:scheme] = params[:target]
        end
        
        o = Gym::Options.available_options + available_options
        o = o.uniq { |op|
            op.key
        }
        config = FastlaneCore::Configuration.create(o, params.values)
        FastlaneCore::Project.detect_projects(config)
        project = FastlaneCore::Project.new(config)
        project.select_scheme
        result = project.app_name.to_s
        
        if result.length > 0
        	Helper.log.info "PRODUCT_NAME #{result} found!".green
        else
        	Helper.log.info "PRODUCT_NAME not found".red
        end
        
        return result

        # sh "shellcommand ./path"

        # Actions.lane_context[SharedValues::GET_PRODUCT_NAME_CUSTOM_VALUE] = "my_val"
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "A short description with <= 80 characters of what this action does"
      end

      def self.details
        # Optional:
        # this is your change to provide a more detailed description of this action
        "You can use this action to do cool things..."
      end

      def self.available_options
        # Define all options your action supports. 
        
        # Below a few examples
        [
          FastlaneCore::ConfigItem.new(key: :target,
                                       is_string: true,
                                       optional: true,
                                      ),
          FastlaneCore::ConfigItem.new(key: :scheme,
                                       is_string: true,
                                       optional: true,
                                      ),
          FastlaneCore::ConfigItem.new(key: :configuration,
                                       is_string: true,
                                       optional: true,
                                      ),
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['GET_PRODUCT_NAME_CUSTOM_VALUE', 'A description of what this value contains']
        ]
      end

      def self.return_value
        # If you method provides a return value, you can describe here what it does
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["Your GitHub/Twitter Name"]
      end

      def self.is_supported?(platform)
        # you can do things like
        # 
        #  true
        # 
        #  platform == :ios
        # 
        #  [:ios, :mac].include?(platform)
        # 

        platform == :ios
      end
    end
  end
end
