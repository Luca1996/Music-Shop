class PayPalService
    def initialize(params)
        @order = params[:order]
    end

    def create_payout
        payout = Payout.new(
            :sender_batch_header => {
                :sender_batch_id => "#{@order.id}"    #SecureRandom.hex(8),
                :email_subject => 'You have a Payout!',
            },
            :items => payout_items

        })


    def payout_items
        items = []
        @order.line_items.each do |line_item|
            items << {
                recipient_type: 'EMAIL',
                amount: {
                    value: "#{line_item.price.round(2)}",
                    currency: 'USD',
                },
                note: 'Thanks for your business',
                sender_item_id: "#{line_item.id}"
                #Assuming user email is paypal email
                receiver: "#{line_item.product.user.email}"
            }
        end
        items
    end