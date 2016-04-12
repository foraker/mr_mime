MrMime::Engine.routes.draw do
  resource :impersonation, only: [:create, :destroy]
end
