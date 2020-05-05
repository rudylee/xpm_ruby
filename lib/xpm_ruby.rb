module XpmRuby
  class Error < StandardError; end
  class Unauthorized < Error; end
  class AccessTokenExpired < Unauthorized; end
  class Forbidden < Error; end
end

require "active_support"
require "active_support/core_ext"
require "builder"

require "xpm_ruby/client"
require "xpm_ruby/client/contact"
require "xpm_ruby/connection"
require "xpm_ruby/job"

require "xpm_ruby/schema/client/add"
require "xpm_ruby/schema/client/update"
require "xpm_ruby/schema/client/contact/add"
require "xpm_ruby/schema/client/contact/update"
require "xpm_ruby/schema/job/add"
require "xpm_ruby/schema/job/state"
require "xpm_ruby/schema/job/update"

require "xpm_ruby/staff"
require "xpm_ruby/template"
require "xpm_ruby/version"
