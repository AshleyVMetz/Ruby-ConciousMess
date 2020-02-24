require 'test_helper'

class RipplesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ripple = ripples(:one)
  end

  test "should get index" do
    get ripples_url
    assert_response :success
  end

  test "should get newest after forward" do
    PAGE_SIZE = 10
    page_2 = Ripple.order(created_at: :desc).offset(PAGE_SIZE * 1).limit(PAGE_SIZE)
    page_1 = Ripple.order(created_at: :desc).offset(PAGE_SIZE * 0).limit(PAGE_SIZE)
    get ripples_url(page:"next")
    assert_response :success
    assert_select "td", page_2.first.name
    get ripples_url(page:"newest")
    assert_response :success
    assert_select "td", page_1.first.name

  end

  test "should get oldest and go back 10" do
    PAGE_SIZE = 10
    last_page_num = (Ripple.all.size.to_f / PAGE_SIZE).ceil - 1
    page_sec_to_last = Ripple.order(created_at: :desc).offset(PAGE_SIZE * (last_page_num - 1)).limit(PAGE_SIZE)

    get ripples_url(page: "oldest")
    assert_response :success
    assert_select "td", Ripple.all.last.name
    get ripples_url(page: "prev")
    assert_response :success
    assert_select "td", page_sec_to_last.first.name

  end

  test "should get new" do
    get new_ripple_url
    assert_response :success
  end

  test "should create ripple" do
    assert_difference('Ripple.count') do
      post ripples_url, params: { ripple: { message: @ripple.message, name: @ripple.name, website: @ripple.website } }
    end

    assert_redirected_to ripples_url
  end

  test "should show ripple" do
    get ripple_url(@ripple)
    assert_response :success
  end

  test "should get edit" do
    get edit_ripple_url(@ripple)
    assert_response :success
  end

  test "should update ripple" do
    patch ripple_url(@ripple), params: { ripple: { message: @ripple.message, name: @ripple.name, website: @ripple.website } }
    assert_redirected_to ripple_url(@ripple)
  end

  test "should destroy ripple" do
    assert_difference('Ripple.count', -1) do
      delete ripple_url(@ripple)
    end

    assert_redirected_to ripples_url
  end
end
