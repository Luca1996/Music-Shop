class PayPalService
    def initialize(params)
        @order = params[:order]
    end

    def create_payout
        payout = PayPal::SDK::REST::Payout.new({
            :sender_batch_header => {
                :sender_batch_id => SecureRandom.hex(8),    #"#{@order.id}",    
                :email_subject => 'You have a Payout!'
            },
            :items => payout_items
        });
        payout
    end


    def payout_items
        items = []
        @order.line_items.each do |line_item|
            items << {
                recipient_type: 'EMAIL',
                amount: {
                    value: "#{line_item.price.round(2)}",
                    currency: 'EUR'
                },
                note: 'Thanks for your business',
                sender_item_id: '2014031400023',        #"#{line_item.id}",
                #Assuming user email is paypal email
                receiver: "#{line_item.product.user.email}"
            }
        end
        items
    end

end