module Fastlane
  module Actions
    class BootstrapAction < Action
      def self.run(params)
        Dir.pwd do
          sh "brew bundle"
        end

        other_action.carthage(
          command: "bootstrap",
          no_build: false,
          use_binaries: false,
          platform: "iOS",
          configuration: "Release",
          cache_builds: true,
          project_directory: Dir.pwd
        )
      end

      def self.description
        "Bootstrap project (install dependencies via Carthage and external tools via Homebrew)"
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end
