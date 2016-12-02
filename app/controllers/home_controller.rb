class HomeController < ApplicationController
  respond_to :js

  # ROOT PATH
  def index
    if user_signed_in?
      @pins = Pin.tagged_with(current_user.intrest_list, :on => :genre, :any => true).paginate(:page => params[:page]).order("created_at desc")
    else
      @pins = Pin.paginate(:page => params[:page]).order("created_at desc")
    end

    @res = {
          pins: @pins.as_json(include: { user: {only: [:username, :avatar]}}),
          next_page: @pins.next_page,
          total_pages: @pins.total_pages,
          previous_page: @pins.previous_page,
          total_pages: @pins.total_pages
      }
  end

  def findfriend
    @users = User.all_except(current_user).paginate(:page => params[:page])
  end

  def followers
    @users = User.find_by(username: params[:username]).followers
  end

  def follows
    @follows = User.find_by(username: params[:username]).follows
    @users = []
    @follows.each do |f|
      @users.push(f.followable)
    end
  end

  def profile
    @user = User.find_by(username: params[:username])
    @pins = @user.pins;
    @boards = Board.where(user_id: @user.id)
    @pinsdata = {
        pins: @pins.as_json(include: { user: {only: [:username, :avatar]}})
    }
  end

  def edit_profile

  end

  def savedpins
    @user = User.find_by(username: params[:username])
    @pins = @user.saves.up.saveables

    @pinsdata = {
        pins: @pins.as_json(include: { user: {only: [:username, :avatar]}})
    }

  end

  def board
    @board = Board.find(params[:board_id])
    @user = User.find_by(username: params[:username])
    @pins = @board.pins.order("created_at desc")
  end

  def pins
    @user = User.find_by(username: params[:username])
    @pins = {
        pins: @user.pins.as_json(include: { user: {only: [:username, :avatar]}})
    }
  end
end
