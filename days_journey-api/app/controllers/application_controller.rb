class ApplicationController < ActionController::API
# below codes mean supporting for rails-api 
include ActionController::MimeResponds
include ActionController::StrongParameters
# trying to output json over respond_with
include ActionController::ImplicitRender
# talking with Senser data processing server.
include Liliflora::LilifloraTalker
end
