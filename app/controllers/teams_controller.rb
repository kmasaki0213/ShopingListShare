class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team, only: %i[ show edit update destroy ]

  # GET /teams or /teams.json
  def index
    @teams = Team.all.includes(:owner)
  end

  # GET /teams/1 or /teams/1.json
  def show
    @team = Team.find(params[:id])
    @members = @team.users.includes(:teams)
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
    @team = Team.find(params[:id])
  
    unless @team.owner == current_user
      flash[:alert] = "チーム名を変更できるのはオーナーのみです！"
      redirect_to @team
    end
  end
  
  # POST /teams or /teams.json
  def create
    @team = Team.new(team_params)
    @team.owner = current_user

    if @team.save
      current_user.teams << @team # 自分をメンバーに追加
      redirect_to @team, notice: 'チームを作成しました！'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /teams/1 or /teams/1.json
  def update
    @team = Team.find(params[:id])
  
    if @team.owner == current_user && @team.update(team_params)
      flash[:notice] = "チーム名を更新しました！"
      redirect_to @team
    else
      flash[:alert] = "チーム名の更新に失敗しました。"
      render :edit, status: :unprocessable_entity
    end
  end
  
  # DELETE /teams/1 or /teams/1.json
  def destroy
    @team.destroy!
    redirect_to dashboard_path, notice: "チーム「#{@team.name}」を解散しました。"
  end

  def join
    @team = Team.find(params[:id])
  
    unless current_user.teams.include?(@team)
      current_user.teams << @team
      flash[:notice] = "#{@team.name} に参加しました！"
    else
      flash[:alert] = "すでに #{@team.name} に参加しています！"
    end
  
    redirect_to @team # 参加後、チームの詳細ページへ移動
  end

  def members
    @team = Team.find(params[:id])
    @users = User.where.not(id: @team.users.pluck(:id)) # まだ参加していないユーザーを取得
  end
  
  def add_member
    @team = Team.find(params[:id])
    user = User.find(params[:user_id])
  
    if user.teams.include?(@team)
      flash[:alert] = "#{user.name} さんはすでにチームに参加しています！"
    else
      user.teams << @team
      flash[:notice] = "#{user.name} さんを追加しました！"
    end
  
    redirect_to @team
  end

  def transfer_ownership
    @team = Team.find(params[:id])
    new_owner = User.find(params[:user_id])
  
    if @team.owner == current_user && @team.users.include?(new_owner)
      @team.update(owner: new_owner)
      flash[:notice] = "#{new_owner.name} さんにオーナー権限を譲渡しました！"
    else
      flash[:alert] = "オーナー権限を譲渡できません。"
    end
  
    redirect_to @team
  end  

  def leave
    @team = Team.find(params[:id])
  
    if @team.owner == current_user
      flash[:alert] = "オーナーはチームを抜けられません！"
    else
      current_user.teams.delete(@team)
      flash[:notice] = "チーム「#{@team.name}」から抜けました！"
    end
  
    redirect_to dashboard_path
  end
  
  def remove_member
    @team = Team.find(params[:id])
    user = User.find(params[:user_id])
  
    if @team.owner == user
      flash[:alert] = "オーナーは追放できません！"
    else
      @team.users.delete(user)
      flash[:notice] = "#{user.name} さんをチームから追放しました！"
    end
  
    redirect_to @team
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def team_params
      params.require(:team).permit(:name)
    end

    def ensure_owner
      redirect_to dashboard_path, alert: "権限がありません。" unless @team.owner == current_user
    end
end
