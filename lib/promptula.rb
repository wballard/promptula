require "promptula/version"
require "rainbow"
module Promptula
  SEPARATOR = "\u25B6"
  SEPARATOR_THIN = "\u276F"
  PATH_SEPARATOR = '/'
  BACKGROUND = "3a3a3a"
  GLYPH = "\u2733"
  PULL_ARROW = "\u2798"
  PUSH_ARROW = "\u279A"

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
    if system 'git status > /dev/null 2>/dev/null'
      branch = `git rev-parse --abbrev-ref HEAD 2>/dev/null`.chomp
      branch.split("\n").each do |line|
        if line[0] == '*'
          branch = line.sub('*', '').chomp
        end
      end
      tracking = Hash[`git for-each-ref --format='%(refname:short) %(upstream:short)' refs/heads`
        .split("\n")
        .map {|l| l.split ' '}]
      status = `git status --ignore-submodules --porcelain`
      untracked = (status.match('\?\?') or '').size > 0 ? " #{GLYPH}" : ''
      dirty = status.size > 0
      background = dirty ? :red : :green
      prompt = SEPARATOR.foreground(background).background(BACKGROUND).inverse
      prompt += "#{branch}#{untracked} ".background(background)
      remote = tracking[branch]
      if remote
        push_pull  = `git rev-list --left-right #{remote}...HEAD`.split("\n")
        to_push = (push_pull.select {|m| m.start_with? '>'}).length
        to_pull = (push_pull.select {|m| m.start_with? '<'}).length
        if to_pull > 0
          prompt += "#{PULL_ARROW}#{to_pull} ".background(background)
        end
        if to_push > 0
          prompt += "#{PUSH_ARROW}#{to_push} ".background(background)
        end
      end
      prompt += SEPARATOR.foreground(background).reset()
      prompt
    else
      ''
    end
  end

  def self.prompt()
    Sickill::Rainbow.enabled = true
    cwd() + git()
  end
end
