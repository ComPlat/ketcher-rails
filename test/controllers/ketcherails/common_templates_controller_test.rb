require 'test_helper'

module Ketcherails
  class CommonTemplatesControllerTest < ActionController::TestCase
    setup do
      @common_template = ketcherails_common_templates(:one)
      @routes = Engine.routes
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:common_templates)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create common_template" do
      assert_difference('CommonTemplate.count') do
        post :create, common_template: { approved_at: @common_template.approved_at, name: @common_template.name, notes: @common_template.notes, rejected_at: @common_template.rejected_at }
      end

      assert_redirected_to common_template_path(assigns(:common_template))
    end

    test "should show common_template" do
      get :show, id: @common_template
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @common_template
      assert_response :success
    end

    test "should update common_template" do
      patch :update, id: @common_template, common_template: { approved_at: @common_template.approved_at, name: @common_template.name, notes: @common_template.notes, rejected_at: @common_template.rejected_at }
      assert_redirected_to common_template_path(assigns(:common_template))
    end

    test "should destroy common_template" do
      assert_difference('CommonTemplate.count', -1) do
        delete :destroy, id: @common_template
      end

      assert_redirected_to common_templates_path
    end
  end
end
