require "promptula/version"
require "rainbow"
module Promptula

  LEFT_EDGE = "\u25C0"
  RIGHT_EDGE = "\u25B6"
  GLYPH = "\u2733"
  PULL_ARROW = "\u2798"
  PUSH_ARROW = "\u279A"

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
      prompt = LEFT_EDGE.foreground(background)
      prompt += "#{branch}#{untracked}".foreground(background).background(:white).inverse()
      remote = tracking[branch]
      if remote
        push_pull  = `git rev-list --left-right #{remote}...HEAD`.split("\n")
        to_push = (push_pull.select {|m| m.start_with? '>'}).length
        to_pull = (push_pull.select {|m| m.start_with? '<'}).length
        if to_pull > 0
          prompt += " #{PULL_ARROW}#{to_pull}".foreground(background).background(:white).inverse()
        end
        if to_push > 0
          prompt += " #{PUSH_ARROW}#{to_push}".foreground(background).background(:white).inverse()
        end
      end
      prompt += RIGHT_EDGE.foreground(background)
      prompt.chomp
    else
      ''
    end
  end

  def self.prompt()
    Sickill::Rainbow.enabled = true
    git()
  end
end
