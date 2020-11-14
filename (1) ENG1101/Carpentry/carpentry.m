function [ net_profit, wood_quantity, labor_quantity ] = carpentry( quantity, wood_cost, labor_cost )
    %receives the quantities of products wanted and sends the amount of
    %materials and profit
    revenue = dot(quantity, [750, 520, 340, 177]);

    wood_quantity = dot(quantity, [145, 130, 95, 55]);
    wood_cost = wood_cost*wood_quantity;

    labor_quantity = dot(quantity, [12, 9, 7, 5]);
    labor_cost = labor_quantity*labor_cost;

    net_profit = revenue - wood_cost - labor_cost;

end

