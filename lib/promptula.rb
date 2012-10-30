require "promptula/version"
require "rainbow"
module Promptula
  SEPARATOR = "\u25B6"
  SEPARATOR_THIN = "\u276F"
  PATH_SEPARATOR = '/'
  BACKGROUND = "3a3a3a"
  GLYPH = "\u2733"

  def self.cwd()
    current = Dir.pwd
    home = ENV['HOME']
    ret = ''
    current.sub(home, '~').split('/').each do |segment|
      ret += PATH_SEPARATOR.foreground(:black).background(BACKGROUND) if segment != '~'
      ret += "#{segment}".background BACKGROUND
    end
    ret + ' '.background(BACKGROUND)
  end

  def self.git()
    branch = ''
    `git branch 2>/dev/null`.split("\n").each do |line|
      if line[0] == '*'
        branch = line.sub('*', '').chomp
      end
    end
    status = `git status --porcelain 2>/dev/null`
    untracked = (status.match('\?\?') or '').size > 0 ? " #{GLYPH}" : ''
    dirty = status.size > 0
    background = dirty ? :red : :green

    SEPARATOR.foreground(background).background(BACKGROUND).inverse + 
    "#{branch}#{untracked} ".background(background) +
    SEPARATOR.foreground(background).reset()
  end

  def self.prompt()
    Sickill::Rainbow.enabled = true
    cwd() + git()
  end
end
