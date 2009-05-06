class Animal < ActiveRecord::Base
  belongs_to :site
  
  has_many :samples, :dependent => :destroy
  
  has_many :cohort_assignments, :as => :assignable, :dependent => :destroy
  has_many :cohorts, :through => :cohort_assignments
  
  has_many :medications, :dependent => :destroy
  has_many :animal_evaluations, :dependent => :destroy
  has_many :lab_tests, :order => 'collected_at ASC', :dependent => :destroy
  
  validates_presence_of :code, :site_id
  
  def name
    "Cow #{code}"
  end
  
end