class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team

  def new
    @team = Team.find(params[:team_id])
    @item = @team.items.new
    render layout: false # ✅ Turbo Frame 用にレイアウトなしで表示
  end
  
  def create
    @team = Team.find(params[:team_id])
    @item = @team.items.new(item_params.merge(user: current_user))
  
    if @item.save
      redirect_to team_path(@team), notice: "アイテム「#{@item.name}」を登録しました！"
    else
      render :new, status: :unprocessable_entity, layout: false
    end
  end
  
  def show
    @team = Team.find(params[:team_id])
    @item = @team.items.find(params[:id])
    render layout: false
  end

  def edit
    @team = Team.find(params[:team_id])
    @item = @team.items.find(params[:id])
    render layout: false
  end
  
  def update
    @team = Team.find(params[:team_id])
    @item = @team.items.find(params[:id])
  
    if @item.update(item_params)
      redirect_to team_path(@team), notice: "アイテム「#{@item.name}」を更新しました！"
    else
      render :edit, status: :unprocessable_entity, layout: false
    end
  end

  def destroy
    @team = Team.find(params[:team_id])
    @item = @team.items.find(params[:id])
    @item.destroy
  
    redirect_to team_path(@team), notice: "アイテム「#{@item.name}」を削除しました！"
  end

  def history
    @team = Team.find(params[:team_id])
    @items = @team.items.history
  end
  
  def toggle_status
    @team = Team.find(params[:team_id])
    @item = @team.items.find(params[:id])
  
    case params[:status]
    when "purchased"
      @item.update!(status: "purchased", purchased_at: Time.current)
    when "rejected"
      @item.update!(status: "rejected", purchased_at: nil)
    else
      @item.update!(status: "unpurchased", purchased_at: nil)
    end
  
    redirect_to team_path(@team), notice: "アイテム「#{@item.name}」を削除しました！"
  end
  
  private

    def set_team
      @team = Team.find(params[:team_id])
    end

    def item_params
      params.require(:item).permit(:name, :description, :price, :quantity)
    end
end
