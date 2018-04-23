class CategoryRulesController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_user!
  before_action :set_category_rule, only: [:show, :edit, :update, :destroy]
  before_action :authorize_category_rule, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @category_rule = CategoryRule.new
  end

  def edit
  end

  def create
    @category_rule = current_user.category_rules.build(category_rule_params)

    if @category_rule.save
       redirect_to category_path(@category_rule.category), notice: 'Category rule was successfully created.'
    else
      render :new
    end
  end

  def update
    if @category_rule.update(category_rule_params)
      redirect_to category_path(@category_rule.category), notice: 'Category rule was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @category_rule.destroy
    redirect_to category_path(@category_rule.category), notice: 'Category rule was successfully destroyed.'
  end

  private

  def set_category_rule
    @category_rule = CategoryRule.find(params[:id])
  end

  def authorize_category_rule
    authorize @category_rule
  end

  def category_rule_params
    params.require(:category_rule).permit(:category_id,
                                      :match_status,
                                      :match_payee,
                                      :match_memo,
                                      :match_address,
                                      :match_category
                                    )
  end
end
