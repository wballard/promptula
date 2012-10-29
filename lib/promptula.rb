require "promptula/version"
require "rainbow"
module Promptula
  SEPARATOR = "\u25B6"
  SEPARATOR_THIN = "\u276F"
  #PATH_SEPARATOR = "\u22F0"
  PATH_SEPARATOR = '/'
  BACKGROUND = "3a3a3a"

  def self.pre(color)
    SEPARATOR.foreground(color).background(BACKGROUND).inverse
  end

  def self.post(color)
    SEPARATOR.foreground(color).reset()
  end

  def self.cwd()
    current = Dir.pwd
    home = ENV['HOME']
    ret = ''
    current.sub(home, '~').split('/').each do |segment|
      ret += PATH_SEPARATOR.foreground(:black).background(BACKGROUND) if segment != '~'
      ret += "#{segment}".background BACKGROUND
    end
    "#{ret}"
  end

  def self.git()
    branch = '<unknown>'
    `git branch`.split("\n").each do |line|
      if line[0] == '*'
        branch = line.sub('*', '').chomp
      end
    end
    status = `git status --porcelain`
    untracked = (status.match('\?\?') or '').size > 0 ? '+' : ''
    dirty = status.size > 0
    background = dirty ? :red : :green

    pre(background) + 
    "#{branch}#{untracked} ".background(background) +
    post(background)
  end

  def self.prompt()
    Sickill::Rainbow.enabled = true
    (cwd() + git())
  end
end
