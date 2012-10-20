#!/usr/bin/env ruby
require_relative 'terminal_runner.rb'

class WStrip < TerminalRunner
  name "WStrip"

  param "input", "The file or directory of files to strip whitespace from."

  option "--help", 0, "", "Shows this help file."
  option "--recursive", 0, "", "Recursively get files from directories."
  option_alias "--recursive", "-r"
  help <<EOS
    Removes all extra whitespace from the end of lines.
EOS

  def self.run
    if @@options.include? "--help"
      show_usage
      exit
    end
    ws = WStrip.new(@@params["input"], @@options.include?("--recursive"))
  end

  def initialize(input, r)
    unless File.exists? input
      puts "Could not find input file."
      exit
    end

    strip_file(input, r)
  end

  def strip_file(file, r)
    puts "Stripping #{file}."
    if File.directory? file
      Dir.entries(file).select do |f|
        if (f != "." && f != "..")
          file_full = "#{file}/#{f}"
          if File.directory?(file_full)
            if r
              strip_file(file_full, r)
            end
          else
            strip_file(file_full, r)
          end
        end
      end
    else
      lines = []
      File.open(file, 'r').each_line do |line|
        lines << line.rstrip
      end
      File.open(file, 'w') do |f|
        lines.each do |line|
          f.puts line
        end
      end
    end
  end
end

if __FILE__ == $0
  x = WStrip.start(ARGV)
end
