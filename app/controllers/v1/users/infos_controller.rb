module V1
  module Users
    class InfosController < ApplicationController
      def show
        render json: { message: "Boa, você realmente conseguiu consumir a api como um mestre, isso ae campeão!" }
      end
    end
  end
end