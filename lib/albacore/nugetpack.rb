require "albacore/albacoretask"
require "albacore/config/nugetpackconfig"

class NuGetPack
  TaskName = :nugetpack

  include Albacore::Task
  include Albacore::RunCommand
  include Configuration::NuGetPack
  
  attr_reader   :symbols
  
  attr_accessor :nuspec,
                :output_directory,
                :base_path

  attr_hash     :properties

  def initialize()
    @command = "nuget"

    super()
    update_attributes(nugetpack.to_hash)
  end

  def execute  
    unless @nuspec
      fail_with_message("nugetpack requires #nuspec" )
      return
    end
    
    result = run_command("nugetpack", build_parameters)
    fail_with_message("NuGet Pack failed, see the build log for more details.") unless result
  end

  def build_parameters
    p = []
    p << "pack"
    p << "-Symbols" if @symbols
    p << "\"#{@nuspec}\""
    p << "-BasePath \"#{@base_path}\"" if @base_path
    p << "-OutputDirectory \"#{@output_directory}\"" if @output_directory
    p << "-Properties #{@properties.map { |key, value| "#{key}=\"#{value}\"" }.join(";")}" if @properties
    p
  end
  
  def symbols
    @symbols = true
  end
end