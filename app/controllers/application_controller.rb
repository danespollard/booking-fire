class ApplicationController < ActionController::Base
  include Authentication
  allow_browser versions: { safari: 16.4, chrome: 111, edge: 111, firefox: 128, opera: 97, ie: false }
end
