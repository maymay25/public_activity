# encoding: utf-8
class Activity < ActiveRecord::Base

    attr_accessible :trackable_id, :trackable_type, :owner_id, :owner_type, 
                    :recipient_id, :recipient_type, :key, :parameters


    belongs_to :trackable, :polymorphic => true

    belongs_to :owner, :polymorphic => true

    belongs_to :recipient, :polymorphic => true

    serialize :parameters, Hash

end
