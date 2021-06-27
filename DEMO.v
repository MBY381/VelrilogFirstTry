 `timescale 1ns / 1ps
module test1 (clk,reset,num_input,cal_input,enter,ans);//,middle,tmp_num,tmp_cal,stack_num,index_num,index_cal,shuchu);
    input clk;
    input reset; 
    input num_input;
    input cal_input;
    input enter;

    output [7:0]ans;
    /*
    output [7:0]tmp_num;
    output [7:0]tmp_cal;
    output [127:0]stack_num;
    output [7:0]index_num;
    output [7:0]index_cal;
    */
    reg [7:0]ans; 
    reg [127:0]stack_num;
    reg [127:0]stack_cal;
    reg [7:0]tmp_num;
    reg [7:0]tmp_cal;

    //reg [7:0]index_num;
    reg [7:0]index_cal;
    reg [127:0]tmp;
    
    reg [7:0]tail;
    reg [7:0]num1;
    reg [7:0]num2;
    reg [7:0]cal1;
    always @(posedge clk) begin
    tmp=tmp+1;
    if(tmp>100000000)begin
        if(~reset) begin
            tmp=0;
            ans = 0;
            tmp_num=0;
            tmp_cal=0;
            //index_num=0;
            index_cal=0;
            stack_num=0;
            stack_cal=0;
        end
        else begin
            if(num_input==0)
                begin
                tmp=0;
                    if(tmp_cal!=0)begin
                        //if(stack_cal[7:0]>=tmp_cal) begin
                            repeat(3) begin

                                    if(stack_cal[7:0]>=tmp_cal && index_cal) begin
                                
                                        num1= stack_num[7:0];
                            
                                        num2 = stack_num[15:8];
                                        stack_num = stack_num>>8;
                            
                                        cal1 = stack_cal[7:0];
                                        stack_cal = stack_cal>>8;

                                        index_cal = index_cal-1;


                                        if(cal1==2) begin
                                           num1=num1+num2;
                                        end
                                        else if(cal1==3) begin
                                            num1=num2-num1;
                                        end
                                        else if(cal1==4) begin
                                            num1=num1*num2;
                                        end
                                        else if(cal1==5) begin
                                            num1=num2/num1;
                                        end



                                        stack_num[7:0] = num1;
                                    end
                            end
                        //end
                     
                        stack_cal =(stack_cal<<8);
                        stack_cal = stack_cal + tmp_cal ;
                        index_cal = index_cal+1;
                        tmp_cal= 0;
                    end
                    tmp_num=tmp_num+1;
                    ans=tmp_num;
                end
            else begin
                if(cal_input==0) begin
                    tmp=0;
                    if(tmp_num!=0)begin
                        stack_num =(stack_num<<8);
                        
                        stack_num = stack_num + tmp_num ;
                        //index_num = index_num+1;
                        tmp_num = 0 ;
                    end
                    tmp_cal=tmp_cal+1;
                    ans=tmp_cal;
                end
                else begin
                    if(enter==0) begin
                        tmp=0;
                        if(tmp_num!=0 || tmp_cal!=0) begin
                        
                            if(tmp_num!=0)begin
                                /////
                                stack_num =(stack_num<<8);
                                stack_num = stack_num + tmp_num ;
                                //////
                                tmp_num = 0 ;
                            end 
                            else begin
                            if(tmp_cal!=0)begin
                                stack_cal =(stack_cal<<8);
                                stack_cal = stack_cal + tmp_cal ;
                                index_cal = index_cal+1;
                                tmp_cal= 0;
                            end
                            end
                        
                        
                        end
                        else  begin
                            repeat(4) begin
                                    if(index_cal) begin
                                //ans=128+index_num;
                                    num1= stack_num[7:0];
                            
                                    num2 = stack_num[15:8];
                                    stack_num = stack_num>>8;
                            
                                    cal1 = stack_cal[7:0];
                                    stack_cal = stack_cal>>8;

                                    index_cal = index_cal-1;
                                    if(cal1==2) begin
                                       num1=num1+num2;
                                    end
                                    else if(cal1==3) begin
                                        num1=num2-num1;
                                    end
                                    else if(cal1==4) begin
                                        num1=num1*num2;
                                    end
                                    else if(cal1==5) begin
                                        num1=num2/num1;
                                    end
                                    stack_num[7:0] = num1;
                                    end
                            end
                        ans=stack_num[7:0];
                        end
                    end
                end
            end
        end
    end
    end
endmodule