module Roboto
  #provides the content of effective robots.txt file
  class ContentProvider
    # Reads the contents of the effective robots.txt file
    # @return [String] the contents of the effective robots.txt file
    def contents
      @contents ||= File.read(path)
    end

    # Determines the most relevant robots.txt file.
    #
    # It checks for the paths in the following order
    #
    # 1. Rails.root/config/robots/<environment>.txt (ie production.txt)
    # 2. Rails.root/config/robots/default.txt
    # 3. The default, blank robots.txt provided by the gem
    # @return [Path] the path of the effective robots.txt file
    def path
      lookup_paths.each do |f|
        if FileTest.exist?(f)
          return f
        end
      end

      #this should never occur because we define a default in the gem
      raise "Robots file not found"
    end

    protected
    def lookup_paths
      [
        Rails.root.join("config/robots/#{Rails.env}.txt"),
        Rails.root.join(relative_path_to_default),
        Roboto::Engine.root.join(relative_path_to_default)
      ]
    end

    def relative_path_to_default
      "config/robots/default.txt"
    end
  end
end

