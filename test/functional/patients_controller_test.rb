require 'test_helper'

class PatientsControllerTest < ActionController::TestCase
  def test_should_get_index_superuser_and_admin
    [:superuser, :admin].each do |user|
      login_as user
      get :index
      assert_response :success
      assert_not_nil assigns(:patients)
      assert_equal 2, assigns(:patients).size
    end
  end
  
  def test_should_get_index_user
    login_as :user
    get :index
    assert_response :success
    assert_not_nil assigns(:patients)
    assert_equal 1, assigns(:patients).size
  end

  def test_should_get_new
    login_as :user
    get :new
    assert_response :success
  end

  def test_should_create_patient
    login_as :user
    assert_difference('Patient.count') do
      post :create, :patient => { :code => 'TESTCODE', :site_id => sites(:one).id }
    end

    assert_redirected_to patient_path(assigns(:patient))
  end

  def test_should_show_patient
    login_as :user
    get :show, :id => patients(:one).id
    assert_response :success
  end
  
  def test_should_not_get_patient_different_site
    login_as :user
    assert_raise ActiveRecord::RecordNotFound do
      get :show, :id => patients(:two).id
    end
  end
  
  def test_should_get_patient_different_site_admin_and_superuser
    [:superuser, :admin].each do |user|
      login_as user
      get :show, :id => patients(:one).id
      assert_response :success
    end
  end

  def test_should_get_edit
    login_as :user
    get :edit, :id => patients(:one).id
    assert_response :success
  end
  
  def test_should_not_get_edit_different_site
    login_as :user
    assert_raise ActiveRecord::RecordNotFound do
      get :edit, :id => patients(:two).id
    end
  end
  
  def test_should_get_edit_different_site_admin_and_superuser
    [:superuser, :admin].each do |user|
      login_as user
      get :edit, :id => patients(:one).id
      assert_response :success
    end
  end

  def test_should_update_patient
    login_as :user
    put :update, :id => patients(:one).id, :patient => { }
    assert_redirected_to patient_path(assigns(:patient))
  end
  
  def test_should_not_update_patient_different_site
    login_as :user
    assert_raise ActiveRecord::RecordNotFound do
      put :update, :id => patients(:two).id, :patients => { }
    end
  end
  
  def test_should_update_patient_different_site_admin_and_superuser
    [:superuser, :admin].each do |user|
      login_as user
      put :update, :id => patients(:one).id, :patient => { }
      assert_redirected_to patient_path(assigns(:patient))
    end
  end

  def test_should_destroy_patient
    login_as :user
    assert_difference('Patient.count', -1) do
      delete :destroy, :id => patients(:one).id
    end

    assert_redirected_to patients_path
  end
  
  def test_should_not_destroy_patient_different_site
    login_as :user
    assert_raise ActiveRecord::RecordNotFound do
      delete :destroy, :id => patients(:two).id
    end
  end
  
  def test_should_destroy_patient_different_site_admin
    login_as :admin
    assert_difference('Patient.count', -1) do
      delete :destroy, :id => patients(:one).id
    end
    
    assert_redirected_to patients_path
  end
  
  def test_should_destroy_patient_different_site_superuser
    login_as :superuser
    assert_difference('Patient.count', -1) do
      delete :destroy, :id => patients(:one).id
    end
    
    assert_redirected_to patients_path
  end
end
