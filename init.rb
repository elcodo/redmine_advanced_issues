require 'redmine'
require 'dispatcher'

RAILS_DEFAULT_LOGGER.info 'Starting advenced Issues Plugin for RedMine'

Dispatcher.to_prepare do

  # add time unit conversion
  Issue.send(:include, RedmineAdvancedIssues::Patches::IssuePatch) unless Issue.included_modules.include? RedmineAdvancedIssues::Patches::IssuePatch  
  TimeEntry.send(:include, RedmineAdvancedIssues::Patches::TimeEntryPatch) unless TimeEntry.included_modules.include? RedmineAdvancedIssues::Patches::TimeEntryPatch

  # add spent time column
  Query.send(:include, RedmineAdvancedIssues::Patches::QueryPatch) unless Query.include?(RedmineAdvancedIssues::Patches::QueryPatch)
  QueriesHelper.send(:include, RedmineAdvancedIssues::Patches::QueriesHelperPatch) unless QueriesHelper.include?(RedmineAdvancedIssues::Patches::QueriesHelperPatch)
  
end

Redmine::Plugin.register :redmine_advanced_issues do
  name 'Redmine Advanced Issues plugin'
  author 'Tieu-Philippe KHIM'
  description '
This is a plugin for Redmine, that add some advanced stuffs.
Spent time columns, unit time customize
'
  version '0.0.3'
  url 'http://blog.spikie.info/'
  author_url 'http://blog.spikie.info'

  # Minimum version of Redmine.
  requires_redmine :version_or_higher => '0.9.0'

  settings(:default => {
             'hours_in_day' => '7.4',
             'char_for_day' => 'd',

             'days_in_week' => '5',
             'char_for_week' => 'w',

             'weeks_in_month' => '21',
             'char_for_month' => 'm',

             'months_in_year' => '12',
             'char_for_year' => 'y',

             'default_unit' => 'hours',

           }, :partial => 'settings/advanced_issues_settings')


end

require 'hooks/controller_issues_edit_before_save_hook'
require 'hooks/controller_timelog_edit_before_save_hook'
