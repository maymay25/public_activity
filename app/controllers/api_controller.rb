# -*- coding:utf-8 -*-
class ApiController < ApplicationController

  def get

    render :json=>{action:params[:action]}

  end

  def post

    render :json=>{action:params[:action]}

  end

  def put

    render :json=>{action:params[:action]}

  end

  def delete

    render :json=>{action:params[:action]}

  end




end
