require "promptula/version"
require "rainbow"
module Promptula
  SEPARATOR = "\u25B6"
  SEPARATOR_THIN = "\u276F"
  BACKGROUND = "3a3a3a"

  def self.cwd()
    current = Dir.pwd
    home = ENV['HOME']
    ret = ''
    current.sub(home, '~').split('/').each do |segment|
      ret += " #{segment} ".foreground(:default).background BACKGROUND
      ret += SEPARATOR_THIN.foreground("808080").background BACKGROUND
    end
    ret
  end

  def self.git()
    current =  `git status`
    current
  end

  def self.prompt()
    Sickill::Rainbow.enabled = true
    cwd() + git()
  end
end
