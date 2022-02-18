-- create int_telemetry_db table
CREATE DATABASE IF NOT EXISTS int_telemetry_db;
CREATE TABLE IF NOT EXISTS int_telemetry_db.int_telemetry
(
      timearrived UInt64,
      timedelay Float32,
      dstip FixedString(16),
      dstp Float32,
      dstts Float32,

      hop_delay Float32,
      hop_index Float32,
      hop_jitter Float32,
      link_delay Float32,
      origts Float32,
      protocol Float32,
      reordering Float32,
      seq Float32,
      sink_jitter Float32,
      srcip FixedString(16),
      srcp Float32
) ENGINE = MergeTree()
PARTITION BY timearrived
ORDER BY (timearrived, dstp, dstip);


-- Check how many existing rows there are
-- SELECT COUNT(), 'rows in table items' FROM items;