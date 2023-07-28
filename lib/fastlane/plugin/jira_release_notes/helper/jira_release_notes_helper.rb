module Fastlane
  module Helper
    class JiraReleaseNotesHelper
      # class methods that you define here become available in your action
      # as `Helper::JiraReleaseNotesHelper.your_method`

      def self.plain_format(issues)
        issues.map { |i| "[#{i.key}] - #{i.summary}" } .join("\n")
      end

      def self.html_format(issues, url)
        require "cgi"
        issues.map do |i|
          summary = CGI.escapeHTML(i.summary)
          "[<a href='#{url}/browse/#{i.key}'>#{i.key}</a>] - #{summary}"
        end.join("\n")
      end
      def self.slack_format(issues, url)
        sorted = issues.sort_by { |i| i.key }
        issues_types = issues.map { |i| i.issuetype.name }.uniq().sort()
        notes = [];
        issues_types.each do |i|
          issues_list = sorted.find_all { |z| z.issuetype.name == i }.map { |z| "* [#{z.key}](#{url}/browse/#{z.key}) - #{z.summary}" }
          notes = notes.concat([ "*#{i}*" ], issues_list)
        end
        notes.join("\n")
      end
    end
  end
end
