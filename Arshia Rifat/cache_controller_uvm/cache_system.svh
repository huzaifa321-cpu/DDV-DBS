module cache_system (
    input logic clk,
    input logic rst_n,
    input logic [31:0] cpu_address,
    input logic cpu_read_enable,
    input logic cpu_write_enable,
    input logic [31:0] cpu_write_data,
    input logic flush_request,
    output logic [31:0] cpu_read_data,
    output logic cpu_ready
);

    // Cache parameters
    parameter int CACHE_SIZE = 256;  // 256 lines
    parameter int LINE_SIZE = 16;    // 16 bytes per line
    parameter int TAG_WIDTH = 20;
    parameter int INDEX_WIDTH = 8;
    parameter int OFFSET_WIDTH = 4;

    // Interconnect signals
    logic [31:0] cache_read_data;
    logic [31:0] cache_write_data;
    logic cache_write_enable;
    logic [31:0] mem_read_data;
    logic [31:0] mem_write_data;
    logic [31:0] mem_address;
    logic mem_write_enable;
    logic mem_ack;

    cache_controller controller (
        .clk(clk),
        .rst_n(rst_n),
        .cpu_address(cpu_address),
        .cpu_read_enable(cpu_read_enable),
        .cpu_write_enable(cpu_write_enable),
        .cpu_write_data(cpu_write_data),
        .cache_read_data(cache_read_data),
        .mem_read_data(mem_read_data),
        .flush_request(flush_request),
        .cache_write_data(cache_write_data),
        .cache_write_enable(cache_write_enable),
        .mem_write_data(mem_write_data),
        .mem_address(mem_address),
        .mem_write_enable(mem_write_enable),
        .cpu_read_data(cpu_read_data),
        .cpu_ready(cpu_ready),
        .mem_ack(mem_ack)
    );

    cache_memory cache (
        .clk(clk),
        .address(cpu_address),
        .write_enable(cache_write_enable),
        .write_data(cache_write_data),
        .read_data(cache_read_data)
    );

    main_memory mem (
        .clk(clk),
        .address(mem_address),
        .write_enable(mem_write_enable),
        .write_data(mem_write_data),
        .read_data(mem_read_data),
        .mem_ack(mem_ack)
    );

endmodule