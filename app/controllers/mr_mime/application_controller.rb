module MrMime
  class ApplicationController < ActionController::Base
    include ImpersonationBehavior
  end
end
