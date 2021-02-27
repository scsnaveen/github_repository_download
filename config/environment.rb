# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!
ActionController::Streaming::X_SENDFILE_HEADER = 'X-Accel-Redirect'  

