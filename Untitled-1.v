
// AHB Master


module AHB_Master1(Hclk,Hresetn,Hresp,Hrdata,Hwrite,Hreadyin,Hreadyout,Htrans,Hwdata,Haddr);

input Hclk,Hresetn,Hreadyout;
input [1:0]Hresp;
input [31:0] Hrdata;
output reg Hwrite,Hreadyin;
output reg [1:0] Htrans;
output reg [31:0] Hwdata,Haddr;

reg [2:0] Hburst;
reg [2:0] Hsize;
integer i,j,k;


task single_write();
 begin
  @(posedge Hclk)
  #2;
   begin
    Hwrite=1;
    Htrans=2'b10;
    Hsize=3'b000;
    Hburst=3'b000;
    Hreadyin=1;
    Haddr=32'h8000_0001;
   end
  
  @(posedge Hclk)
  #2;
   begin
    Htrans=2'b00;
    Hwdata=8'hA3;
   end 
 end
endtask


task single_read();
 begin
  @(posedge Hclk)
  #2;
   begin
    Hwrite=0;
    Htrans=2'b10;
    Hsize=3'b000;
    Hburst=3'b000;
    Hreadyin=1;
    Haddr=32'h8000_00A2;
   end
  
  @(posedge Hclk)
  #2;
   begin
    Htrans=2'b00;
   end 
 end
endtask

task burst_inc_write();
begin
  @(posedge Hclk) 
  #2;
  begin
    Hwrite = 1;
    Htrans = 2'b10;
    Hsize = 3'b000;
    Hburst = 3'b000;
    Hreadyin = 1;
    Haddr = 32'h8000_0000;
  end
  
  @(posedge Hclk) 
  #2;
  begin
    Haddr = Haddr + 1;
    Hwdata = ($random) % 256;
    Htrans = 2'b11;
  end 
 

  for (i = 0; i < 2; i = i + 1)
  begin 
    @(posedge Hclk) 
    #2;
    begin
      Haddr = Haddr + 1;
      Hwdata = ($random) % 256;
      Htrans = 2'b11;
    end
    @(posedge Hclk);
  end
 
  @(posedge Hclk) #2;
  begin
    Hwdata = ($random) % 256;
    Htrans = 2'b00;
  end 
end
endtask


task burst_wrap_write();
    begin
      @(posedge Hclk)
      #2;
      begin
        Hwrite = 1;
        Htrans = 2'b10;
        Hsize = 3'b000;
        Hburst = 3'b000;
        Hreadyin = 1;
        Haddr = 32'h8000_0001;
      end

      @(posedge Hclk)
      #2;
      begin
        Haddr = {Haddr[31:2], Haddr[1:0] + 1'b1};
        Hwdata = ($random) % 256;
        Htrans = 2'b11;
      end

      for (i = 0; i < 2; i = i + 1)
        begin
          @(posedge Hclk)
          #2;
          Haddr = {Haddr[31:2], Haddr[1] + 1'b1};
          Hwdata = ($random) % 256;
          Htrans = 2'b11;
        end

      @(posedge Hclk)
      
      @(posedge Hclk)
      #2;
      begin
        Hwdata = ($random) % 256;
        Htrans = 2'b00;
      end
    end
  endtask


task burst_inc_read();
  begin
    @(posedge Hclk)
    #2;
    begin
      Hwrite = 1;
      Htrans = 2'b10;
      Hsize = 3'b000;
      Hburst = 3'b000;
      Hreadyin = 1;
      Haddr = 32'h8000_0001;
    end

    for (j = 0; j < 2; j = j + 1)
      for (i = 0; i < 2; i = i + 1)
        begin
          if (i == 0) begin
            @(posedge Hclk)
            #2;
            Haddr = Haddr + 1;
            Htrans = 2'b11;
          end
          else begin
            @(posedge Hclk)
            #2;
            Haddr = Haddr + 1;
            Hwdata = ($random) % 256;
            Htrans = 2'b11;
          end
        end

    for (k = 0; k < 2; k = k + 1)
      begin
        if (k == 0) begin
          @(posedge Hclk)
          #2;
          Htrans = 2'b11;
        end
        else begin
          @(posedge Hclk)
          #2;
          Hwdata = ($random) % 256;
          Htrans = 2'b11;
        end
      end

    @(posedge Hclk)
    #2;
    begin
      Htrans = 2'b11;
    end

    @(posedge Hclk)
    #2;
    begin
      Hwdata = ($random) % 256;
      Htrans = 2'b00;
    end
  end
endtask

task burst_wrap_read();
    begin
      @(posedge Hclk)
      #2;
      begin
        Hwrite = 1;
        Htrans = 2'b10;
        Hsize = 3'b000;
        Hburst = 3'b000;
        Hreadyin = 1;
        Haddr = 32'h8000_0001;
      end

      for (j = 0; j < 2; j = j + 1)
        for (i = 0; i < 2; i = i + 1)
          begin
            if (i == 0) begin
              @(posedge Hclk)
              #2;
              Haddr = {Haddr[31:2], Haddr[1:0] + 1'b1};
              Htrans = 2'b11;
            end
            else begin
              @(posedge Hclk)
              #2;
              Haddr = Haddr + 1;
              Hwdata = ($random) % 256;
              Htrans = 2'b11;
            end
          end

      for (k = 0; k < 2; k = k + 1)
        begin
          if (i == 0) begin
            @(posedge Hclk)
            #2;
            Htrans = 2'b11;
          end
          else begin
            @(posedge Hclk)
            #2;
            Hwdata = ($random) % 256;
            Htrans = 2'b11;
          end
        end

      @(posedge Hclk)
      #2;
      begin
        Htrans = 2'b11;
      end

      @(posedge Hclk)
      #2;
      begin
        Hwdata = ($random) % 256;
        Htrans = 2'b00;
      end
    end
  endtask

endmodule
