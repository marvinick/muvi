require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    it "sets @queue_items to the queue items of the logged in user" do
      daddy = Fabricate(:user)
      session[:user_id] = daddy.id
      queue_item1 = Fabricate(:queue_item, user: daddy)
      queue_item2 = Fabricate(:queue_item, user: daddy)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end
    it "redirects to the sign in page for unauthenticated users " do
      get :index
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "POST create" do
    it "redirects to the my queue page" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(response).to redirect_to my_queue_path
    end

    it "creates a queue item" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end
    it "creates the queue item that is associated with the video" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq(video)
    end
    it "creates the queue item that is associated with the sign in user" do
      daddy = Fabricate(:user)
      session[:user_id] = daddy.id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(daddy)
    end
    it "puts the video as the last one in the queue" do
      daddy = Fabricate(:user)
      session[:user_id] = daddy.id
      monk = Fabricate(:video)
      Fabricate(:queue_item, video: monk, user: daddy)
      south_park = Fabricate(:video)
      post :create, video_id: south_park.id
      south_park_queue_item = QueueItem.where(video_id: south_park.id, user_id: daddy.id).first
      expect(south_park_queue_item.position).to eq(2)
    end
    it "does not add the video the queue if the video is already in the queue" do
       daddy = Fabricate(:user)
      session[:user_id] = daddy.id
      monk = Fabricate(:video)
      Fabricate(:queue_item, video: monk, user: daddy)
      post :create, video_id: monk.id
      expect(daddy.queue_items.count).to eq(1)
    end

    it "redirects to the sign in page for unauthenticated users" do
      post :create, video_id: 3
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "DELETE destroy" do
    it "redirects to the my queue page" do
      session[:user_id] = Fabricate(:user).id
      queue_item = Fabricate(:queue_item)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to my_queue_path
    end

    it "deletes the queue item" do
      daddy = Fabricate(:user)
      session[:user_id] = daddy.id
      queue_item = Fabricate(:queue_item, user: daddy)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(0)
    end

    it "normalizes the remaining queue items" do
      daddy = Fabricate(:user)
      session[:user_id] = daddy.id
      queue_item = Fabricate(:queue_item, user: daddy)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(0)
    end

    it "does not delete the queue item if the queue ite is not in the current user's queue" do
      daddy = Fabricate(:user)
      daddy2 = Fabricate(:user)
      session[:user_id] = daddy.id
      queue_item = Fabricate(:queue_item, user: daddy2)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(1)
    end
    it "redirects to the sign in page for unauthenticated users" do
      delete :destroy, id: 3
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "POST update_queue" do
    context "with valid inputs" do
      it "redirects to my queue page" do
        daddy = Fabricate(:user)
        session[:user_id] = daddy.id
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: daddy, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: daddy, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end

      it "reorders the queue items" do
        daddy = Fabricate(:user)
        session[:user_id] = daddy.id
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: daddy, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: daddy, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(daddy.queue_items).to eq([queue_item2, queue_item1])
      end
      it "normalizes the position number" do
        daddy = Fabricate(:user)
        session[:user_id] = daddy.id
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: daddy, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: daddy, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(daddy.queue_items.map(&:position)).to eq([1,2])
      end
    end
    context "with invalid inputs" do
      it "redirects to my queue page" do
        daddy = Fabricate(:user)
        session[:user_id] = daddy.id
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: daddy, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: daddy, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2.5}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end
      it "sets the flash error message" do
        daddy = Fabricate(:user)
        session[:user_id] = daddy.id
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: daddy, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: daddy, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2.3}, {id: queue_item2.id, position: 1}]
        expect(flash[:error]).to be_present
      end

      it "does not change the queue item" do
        daddy = Fabricate(:user)
        session[:user_id] = daddy.id
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: daddy, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: daddy, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1.3}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end
    context "with unauthenticated users" do
      it "redirects to the sign in path" do
        post :update_queue, queue_items: [{id: 2, position: 2}, {id: 5, position: 1}]
        expect(response).to redirect_to sign_in_path
      end
    end
    context "with queue items that do not belong to the authenticated users" do
      it "does not change the queue items" do
        daddy = Fabricate(:user)
        session[:user_id] = daddy.id
        video = Fabricate(:video)
        daddy2 = Fabricate(:user)
        queue_item1 = Fabricate(:queue_item, user: daddy2, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: daddy, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end

  end
end