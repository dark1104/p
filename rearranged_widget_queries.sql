-- Field:  ipv4 protocol
-- Data Type: Number
-- Widgets:
-- 1. Protocol Numbers by pie chart
-- 2. Bytes accumulated per Protocol Number overall
-- 3. Select a IPV4 address and get the split of protocol Numbers seen per IPV4 address
-- Application arrival pattern based on start time
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_application_name_flow_start_time_agg
ENGINE = AggregatingMergeTree()
ORDER BY (application_name, flow_start_time)
AS
SELECT
    application_name,
    flow_start_time,
    sum(bytes_accumulated) AS total_bytes
FROM flows_raw

GROUP BY application_name, flow_start_time;

-- Field:  ipv4 source address
-- Data Type: String
-- Widgets:
-- 1. Bytes accumulated Per IPV4 address
-- 2. Bytes accumulated Per IPV4 subnet group
-- 3. HTTP URLs seen Per IPV4 address/group
-- 4. Top Port Numbers per IPV4 address(can convert this in to application name based on port number)
-- 5. Top application's by bytes accumulated per IPV4 address 
-- 6. VLANs per IPV4 address
-- 7. https usage(bytes accumulated) for port 443 per IPV4 address
-- 8. FIN/RST per IPV4 address
-- 9. TCP retransmits per IPV4 address
-- SRC/DST IPV4 arrival based on the start time (complex widget)
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_sourceIPv4Address_destinationIPv4Address_flow_start_time_agg
ENGINE = AggregatingMergeTree()
ORDER BY (sourceIPv4Address, destinationIPv4Address, flow_start_time)
AS
SELECT
    sourceIPv4Address,
    destinationIPv4Address,
    flow_start_time,
    count() AS flow_count
FROM flows_raw

GROUP BY sourceIPv4Address, destinationIPv4Address, flow_start_time;

-- Field:  ipv4 destination address
-- Data Type: String
-- Widgets:
-- 1. Bytes accumulated Per IPV4 address
-- 2. Bytes accumulated Per IPV4 subnet group
-- 3. HTTP URLs seen Per IPV4 address/group
-- 4. Top Port Numbers per IPV4 address(can convert this in to application name based on port number)
-- 5. Top application's by bytes accumulated per IPV4 address 
-- 6. VLANs per IPV4 address
-- 7. https usage(bytes accumulated) for port 443 per IPV4 address
-- 8. FIN/RST per IPV4 address
-- 9. TCP retransmits per IPV4 address
-- PORT SRC/DST arrival based on start time (complex widget)
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_sourceTransportPort_destinationTransportPort_flow_start_time_agg
ENGINE = AggregatingMergeTree()
ORDER BY (sourceTransportPort, destinationTransportPort, flow_start_time)
AS
SELECT
    sourceTransportPort,
    destinationTransportPort,
    flow_start_time,
    sum(bytes_accumulated) AS total_bytes
FROM flows_raw

GROUP BY sourceTransportPort, destinationTransportPort, flow_start_time;

-- Field:  mac destination
-- Data Type: String
-- Widgets:
-- 1. Bytes accumulated per MAC address
-- 2. IPV4 address split up of a mac address(destination, source)
-- 3. Applications used by a mac address
-- 4. VLANs seen in a MAC address
-- TCP errors/RST arrival based on flow start time
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_tcp_rst_tcp_fin_flow_start_time_agg
ENGINE = AggregatingMergeTree()
ORDER BY (tcp_rst, tcp_fin, flow_start_time)
AS
SELECT
    tcp_rst,
    tcp_fin,
    flow_start_time,
    sum(tcp_rst) AS total_rst,
    sum(tcp_fin) AS total_fin
FROM flows_raw

GROUP BY tcp_rst, tcp_fin, flow_start_time;

-- Field:  mac source
-- Data Type: String
-- Widgets:
-- 1. Bytes accumulated per MAC address
-- 2. IPV4 address split up of a mac address(destination, source)
-- 3. Applications used by a mac address
-- 4. VLANs seen in a MAC address"
-- Protocol Numbers by pie chart
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_protocolIdentifier_agg
ENGINE = AggregatingMergeTree()
ORDER BY (protocolIdentifier)
AS
SELECT
    protocolIdentifier,
    count() AS total_flows
FROM flows_raw

GROUP BY protocolIdentifier;

-- Field:  transport source-port
-- Data Type: Number
-- Widgets:
-- 1. SRC port split based on IPV4 source and destination
-- 2. FIN split up of a SRC PORT
-- 3. RST split up of a SRC PORT
-- 4. TCP retransmits per SRC PORT 
-- 5. Bytes accumulated per SRC PORT
-- Bytes accumulated per Protocol Number overall
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_protocolIdentifier_agg
ENGINE = AggregatingMergeTree()
ORDER BY (protocolIdentifier)
AS
SELECT
    protocolIdentifier,
    sum(bytes_accumulated) AS total_bytes
FROM flows_raw

GROUP BY protocolIdentifier;

-- Field:  transport destination-port
-- Data Type: Number
-- Widgets:
-- 1. DST port split based on IPV4 source and destination
-- 2. FIN split up of a DST PORT
-- 3. RST split up of a DST PORT
-- 4. TCP retransmits per DST PORT 
-- 5. Bytes accumulated per DST PORT
-- Select a IPV4 address and get the split of protocol Numbers seen per IPV4 address
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_sourceIPv4Address_protocolIdentifier_agg
ENGINE = AggregatingMergeTree()
ORDER BY (sourceIPv4Address, protocolIdentifier)
AS
SELECT
    sourceIPv4Address,
    protocolIdentifier,
    count() AS protocol_count
FROM flows_raw

GROUP BY sourceIPv4Address, protocolIdentifier;

-- Field:  transport tcp ack-number
-- Data Type: Number
-- Widgets:
-- 
-- Application arrival pattern based on end time
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_application_name_flow_end_time_agg
ENGINE = AggregatingMergeTree()
ORDER BY (application_name, flow_end_time)
AS
SELECT
    application_name,
    flow_end_time,
    sum(bytes_accumulated) AS total_bytes
FROM flows_raw

GROUP BY application_name, flow_end_time;

-- Field:  transport tcp flag 
-- Data Type: (fin/rst)
-- Widgets:
-- 
-- SRC/DST IPV4 arrival based on the end time (complex widget)
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_sourceIPv4Address_destinationIPv4Address_flow_end_time_agg
ENGINE = AggregatingMergeTree()
ORDER BY (sourceIPv4Address, destinationIPv4Address, flow_end_time)
AS
SELECT
    sourceIPv4Address,
    destinationIPv4Address,
    flow_end_time,
    count() AS flow_count
FROM flows_raw

GROUP BY sourceIPv4Address, destinationIPv4Address, flow_end_time;

-- Field:  application-name 
-- Data Type: String
-- Widgets:
-- 1. IPV4 SRC, DST per application name split up
-- 2. Bytes accumulated per application name
-- 3. VLAN number per application name split up
-- 4. TCP RST/FIN split up per application name
-- 5. TCP Retransmissions per application name
-- 6. PORT splitup SRC, DST per application name
-- PORT SRC/DST arrival based on end time (complex widget)
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_sourceTransportPort_destinationTransportPort_flow_end_time_agg
ENGINE = AggregatingMergeTree()
ORDER BY (sourceTransportPort, destinationTransportPort, flow_end_time)
AS
SELECT
    sourceTransportPort,
    destinationTransportPort,
    flow_end_time,
    sum(bytes_accumulated) AS total_bytes
FROM flows_raw

GROUP BY sourceTransportPort, destinationTransportPort, flow_end_time;

-- Field:  http url 
-- Data Type: String
-- Widgets:
-- 
-- TCP errors/RST arrival based on flow end time
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_tcp_rst_tcp_fin_flow_end_time_agg
ENGINE = AggregatingMergeTree()
ORDER BY (tcp_rst, tcp_fin, flow_end_time)
AS
SELECT
    tcp_rst,
    tcp_fin,
    flow_end_time,
    sum(tcp_rst) AS total_rst,
    sum(tcp_fin) AS total_fin
FROM flows_raw

GROUP BY tcp_rst, tcp_fin, flow_end_time;

-- Field:  https url-certificate
-- Data Type: String
-- Widgets:
-- 
-- Bytes accumulated per IPV4 address
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_sourceIPv4Address_agg
ENGINE = AggregatingMergeTree()
ORDER BY (sourceIPv4Address)
AS
SELECT
    sourceIPv4Address,
    sum(bytes_accumulated) AS total_bytes
FROM flows_raw

GROUP BY sourceIPv4Address;

-- Field:  datalink vlan
-- Data Type: Number
-- Widgets:
-- 
-- Bytes accumulated per IPV4 subnet group
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_subnet_group_agg
ENGINE = AggregatingMergeTree()
ORDER BY (subnet_group)
AS
SELECT
    subnet_group,
    sum(bytes_accumulated) AS total_bytes
FROM flows_raw

GROUP BY subnet_group;

-- Field:  interface input physical
-- Data Type: String
-- Widgets:
-- 
-- HTTP URLs seen per IPV4 address/group
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_http_url_sourceIPv4Address_agg
ENGINE = AggregatingMergeTree()
ORDER BY (http_url, sourceIPv4Address)
AS
SELECT
    http_url,
    sourceIPv4Address,
    count() AS url_count
FROM flows_raw

GROUP BY http_url, sourceIPv4Address;

-- Field:  interface output physical
-- Data Type: String
-- Widgets:
-- 
-- Top Port Numbers per IPV4 address (can convert to application name based on port number)
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_sourceTransportPort_sourceIPv4Address_agg
ENGINE = AggregatingMergeTree()
ORDER BY (sourceTransportPort, sourceIPv4Address)
AS
SELECT
    sourceTransportPort,
    sourceIPv4Address,
    sum(bytes_accumulated) AS total_bytes
FROM flows_raw

GROUP BY sourceTransportPort, sourceIPv4Address;

-- Field: Flow start time
-- Data Type: Number
-- Widgets:
-- 1. Application arrival pattern based on start time
-- 2. SRC/DST IPV4 arrival based on the start time(complex widget)
-- 3. PORT SRC/DST arrival based on start time(complex widget)
-- 4. TCP errors/RST arrival based on flow start time
-- Top applications by bytes accumulated per IPV4 address
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_application_name_sourceIPv4Address_agg
ENGINE = AggregatingMergeTree()
ORDER BY (application_name, sourceIPv4Address)
AS
SELECT
    application_name,
    sourceIPv4Address,
    sum(bytes_accumulated) AS total_bytes
FROM flows_raw

GROUP BY application_name, sourceIPv4Address;

-- Field: Flow end time
-- Data Type: Number
-- Widgets:
-- 1. Application arrival pattern based on end time
-- 2. SRC/DST IPV4 arrival based on the end time(complex widget)
-- 3. PORT SRC/DST arrival based on end time(complex widget)
-- 4. TCP errors/RST arrival based on flow end time"
-- VLANs per IPV4 address
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_datalink_vlan_sourceIPv4Address_agg
ENGINE = AggregatingMergeTree()
ORDER BY (datalink_vlan, sourceIPv4Address)
AS
SELECT
    datalink_vlan,
    sourceIPv4Address,
    count() AS vlan_count
FROM flows_raw

GROUP BY datalink_vlan, sourceIPv4Address;

-- Field: Bytes accumulated
-- Data Type: Number
-- Widgets:
-- 1. Per IPV4 address
-- 2. Per Port Number
-- 3. Per application name
-- 4. Per interface name
-- 5. Per http url
-- HTTPS usage (bytes accumulated) for port 443 per IPV4 address
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_sourceIPv4Address_agg
ENGINE = AggregatingMergeTree()
ORDER BY (sourceIPv4Address)
AS
SELECT
    sourceIPv4Address,
    sum(bytes_accumulated) AS https_bytes
FROM flows_raw

GROUP BY sourceIPv4Address;

-- Field: vlan id
-- Data Type: Number
-- Widgets:
-- 
-- FIN/RST per IPV4 address
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_sourceIPv4Address_agg
ENGINE = AggregatingMergeTree()
ORDER BY (sourceIPv4Address)
AS
SELECT
    sourceIPv4Address,
    sum(tcp_fin) AS total_fin,
    sum(tcp_rst) AS total_rst
FROM flows_raw

GROUP BY sourceIPv4Address;

-- Field: Interface name
-- Data Type: String
-- Widgets:
-- 
-- TCP retransmits per IPV4 address
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_sourceIPv4Address_agg
ENGINE = AggregatingMergeTree()
ORDER BY (sourceIPv4Address)
AS
SELECT
    sourceIPv4Address,
    sum(tcp_retransmits) AS total_retransmits
FROM flows_raw

GROUP BY sourceIPv4Address;

