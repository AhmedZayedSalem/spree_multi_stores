module Spree
  class Shop < Spree::Base
    extend FriendlyId
    friendly_id :slug_candidates, use: :history

    acts_as_paranoid

    has_many :products, dependent: :destroy
    has_many :branches, dependent: :destroy
    belongs_to :user, class_name: Spree.user_class, foreign_key: 'user_id'

    validates_presence_of   :name 
    validates_uniqueness_of :name
    validates :slug, length: { minimum: 3 }, allow_blank: true, uniqueness: true 
    after_destroy :punch_slug
    after_restore :update_slug_history
    before_validation :normalize_slug, on: :update
    self.whitelisted_ransackable_attributes = %w[description name slug]
    
    def has_branches?
      branches.any?
    end

    def deleted?
      !!deleted_at
    end

    def self.distinct_by_shop_ids(sort_order = nil)
      sort_column = sort_order.split(" ").first

      # Postgres will complain when using ordering by expressions not present in
      # SELECT DISTINCT. e.g.
      #
      #   PG::InvalidColumnReference: ERROR:  for SELECT DISTINCT, ORDER BY
      #   expressions must appear in select list. e.g.
      #
      #   SELECT  DISTINCT "spree_shops".* FROM "spree_shops" LEFT OUTER JOIN
      #   "spree_variants" ON "spree_variants"."shops_id" = "spree_shops"."id" AND "spree_variants"."is_master" = 't'
      #   AND "spree_variants"."deleted_at" IS NULL LEFT OUTER JOIN "spree_prices" ON
      #   "spree_prices"."variant_id" = "spree_variants"."id" AND "spree_prices"."currency" = 'USD'
      #   AND "spree_prices"."deleted_at" IS NULL WHERE "spree_shops"."deleted_at" IS NULL AND ('t'='t')
      #   ORDER BY "spree_prices"."amount" ASC LIMIT 10 OFFSET 0
      #
      # Don't allow sort_column, a variable coming from params,
      # to be anything but a column in the database
      if ActiveRecord::Base.connection.adapter_name == 'PostgreSQL' && !column_names.include?(sort_column)
        all
      else
        distinct
      end
    end
    private
    def slug_candidates
      [
        :name,
        [:name, :meta_keywords]
      ]
    end
    def normalize_slug
      self.slug = normalize_friendly_id(slug)
    end

    def punch_slug
      # punch slug with date prefix to allow reuse of original
      update_column :slug, "#{Time.now.to_i}_#{slug}"[0..254] unless frozen?
    end

    def update_slug_history
      self.save!
    end


  end
end

