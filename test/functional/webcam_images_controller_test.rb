require 'test_helper'

class WebcamImagesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:webcam_images)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create webcam_image" do
    assert_difference('WebcamImage.count') do
      post :create, :webcam_image => { }
    end

    assert_redirected_to webcam_image_path(assigns(:webcam_image))
  end

  test "should show webcam_image" do
    get :show, :id => webcam_images(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => webcam_images(:one).to_param
    assert_response :success
  end

  test "should update webcam_image" do
    put :update, :id => webcam_images(:one).to_param, :webcam_image => { }
    assert_redirected_to webcam_image_path(assigns(:webcam_image))
  end

  test "should destroy webcam_image" do
    assert_difference('WebcamImage.count', -1) do
      delete :destroy, :id => webcam_images(:one).to_param
    end

    assert_redirected_to webcam_images_path
  end
end
