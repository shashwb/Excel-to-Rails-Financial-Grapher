Rails.application.routes.draw do
  root 'importer#index'
  # this means that the URL '/importer' goes to the 'form' function in the importer controller
  get '/importer', to: 'importer#form', as: 'importer_form'
  # I assume POST here helps the importer import to the database
  post '/', to: 'importer#import', as: 'import_helper'
  get '/graph', to: 'importer#graph', as: 'graph'
end
