RailsAdmin.config do |config|
  config.excluded_models << Commentable
end

RailsAdmin.authenticate_with do 
  current_user && current_user.email == "guillermo@cientifico.net"
end