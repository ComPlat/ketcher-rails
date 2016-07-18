require 'test_helper'

module Ketcherails
  class TemplateCategoriesControllerTest < ActionController::TestCase
    setup do
      @template_category = ketcherails_template_categories(:one)
      @routes = Engine.routes
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:template_categories)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create template_category" do
      assert_difference('TemplateCategory.count') do
        post :create, template_category: { name: @template_category.name }
      end

      assert_redirected_to template_category_path(assigns(:template_category))
    end

    test "should show template_category" do
      get :show, id: @template_category
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @template_category
      assert_response :success
    end

    test "should update template_category" do
      patch :update, id: @template_category, template_category: { name: @template_category.name }
      assert_redirected_to template_category_path(assigns(:template_category))
    end

    test "should destroy template_category" do
      assert_difference('TemplateCategory.count', -1) do
        delete :destroy, id: @template_category
      end

      assert_redirected_to template_categories_path
    end
  end
end
