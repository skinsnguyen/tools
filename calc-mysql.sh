#!/bin/bash
# Hoang-Nam
# 17/03/2025
# Script hiển thị thông tin bộ nhớ MySQL và các thông số cấu hình theo định dạng bảng đẹp mắt

# Lấy dữ liệu từ MySQL và lưu vào biến tạm
mysql_data=$(mysql -e '
    SELECT
        @@binlog_cache_size / 1024 / 1024,
        @@innodb_buffer_pool_size / 1024 / 1024,
        @@innodb_log_buffer_size / 1024 / 1024,
        @@innodb_log_file_size / 1024 / 1024,
        @@key_buffer_size / 1024 / 1024,
        @@query_cache_size / 1024 / 1024,
        @@query_cache_type,
        @@tmp_table_size / 1024 / 1024,
        @@max_heap_table_size / 1024 / 1024,
        @@myisam_sort_buffer_size / 1024 / 1024,
        @@max_connections,
        @@max_connect_errors,
        @@join_buffer_size / 1024 / 1024,
        @@max_allowed_packet / 1024 / 1024,
        @@read_buffer_size / 1024 / 1024,
        @@read_rnd_buffer_size / 1024 / 1024,
        @@sort_buffer_size / 1024 / 1024,
        @@thread_stack / 1024 / 1024,
        @@net_buffer_length / 1024 / 1024,
        @@thread_cache_size,
        @@table_open_cache,
        @@table_definition_cache,
        @@performance_schema_max_table_instances,
        @@slave_parallel_threads,
        @@slave_parallel_max_queued / 1024 / 1024,
        @@open_files_limit,
        @@wait_timeout,
        @@interactive_timeout,
        @@net_read_timeout,
        @@net_write_timeout,
        @@innodb_lock_wait_timeout,
        @@innodb_flush_log_at_trx_commit,
        @@innodb_max_dirty_pages_pct,
        @@innodb_read_io_threads,
        @@innodb_write_io_threads,
        (
            (
                @@binlog_cache_size +
                @@innodb_buffer_pool_size +
                @@innodb_log_buffer_size +
                @@key_buffer_size +
                @@query_cache_size +
                @@tmp_table_size +
                @@max_heap_table_size +
                @@myisam_sort_buffer_size +
                (
                    @@max_connections * (
                        @@binlog_cache_size +
                        @@join_buffer_size +
                        @@max_allowed_packet +
                        @@read_buffer_size +
                        @@read_rnd_buffer_size +
                        @@sort_buffer_size +
                        @@thread_stack +
                        @@net_buffer_length
                    )
                ) +
                (@@slave_parallel_threads * @@slave_parallel_max_queued) +
                (@@open_files_limit * 1024)
            ) / 1024 / 1024 / 1024
        ) AS max_memory_GB;
' -B --silent)

# Định dạng dòng phân cách
line="+---------------------------------+-------------------------+---------------------+------------------+-----------------+"

# Hiển thị bảng
echo "$line"
printf "| %-31s | %-23s | %-19s | %-16s | %-15s |\n" "Parameter" "Value (MB)" "Connections/Threads" "Additional" "Total Memory"
echo "$line"

# Nhóm Global Buffers
printf "| %-31s | %-23s | %-19s | %-16s | %-15s |\n" "binlog_cache_size" "$(printf "%.8f MB" $(echo "$mysql_data" | awk '{print $1}'))" "" "" ""
printf "| %-31s | %-23s | %-19s | %-16s | %-15s |\n" "innodb_buffer_pool_size" "$(printf "%.8f MB" $(echo "$mysql_data" | awk '{print $2}'))" "" "" ""
printf "| %-31s | %-23s | %-19s | %-16s | %-15s |\n" "innodb_log_buffer_size" "$(printf "%.8f MB" $(echo "$mysql_data" | awk '{print $3}'))" "" "" ""
printf "| %-31s | %-23s | %-19s | %-16s | %-15s |\n" "innodb_log_file_size" "$(printf "%.8f MB" $(echo "$mysql_data" | awk '{print $4}'))" "" "" ""
printf "| %-31s | %-23s | %-19s | %-16s | %-15s |\n" "key_buffer_size" "$(printf "%.8f MB" $(echo "$mysql_data" | awk '{print $5}'))" "" "" ""
printf "| %-31s | %-23s | %-19s | %-16s | %-15s |\n" "query_cache_size" "$(printf "%.8f MB" $(echo "$mysql_data" | awk '{print $6}'))" "" "" ""
printf "| %-31s | %-23s | %-19s | %-16s | %-15s |\n" "query_cache_type" "" "" "$(echo "$mysql_data" | awk '{print $7}')" ""
printf "| %-31s | %-23s | %-19s | %-16s | %-15s |\n" "tmp_table_size" "$(printf "%.8f MB" $(echo "$mysql_data" | awk '{print $8}'))" "" "" ""
printf "| %-31s | %-23s | %-19s | %-16s | %-15s |\n" "max_heap_table_size" "$(printf "%.8f MB" $(echo "$mysql_data" | awk '{print $9}'))" "" "" ""
printf "| %-31s | %-23s | %-19s | %-16s | %-15s |\n" "myisam_sort_buffer_size" "$(printf "%.8f MB" $(echo "$mysql_data" | awk '{print $10}'))" "" "" ""
echo "$line"

# Nhóm Per Connection Buffers
printf "| %-31s | %-23s | %-19s | %-16s | %-15s |\n" "Per Connection Buffers" "Value (MB)" "max_connections" "$(echo "$mysql_data" | awk '{print $11}')" ""
printf "| %-31s | %-23s | %-19s | %-16s | %-15s |\n" "- join_buffer_size" "$(printf "%.8f MB" $(echo "$mysql_data" | awk '{print $13}'))" "" "" ""
printf "| %-31s | %-23s | %-19s | %-16s | %-15s |\n" "- max_allowed_packet" "$(printf "%.8f MB" $(echo "$mysql_data" | awk '{print $14}'))" "" "" ""
printf "| %-31s | %-23s | %-19s | %-16s | %-15s |\n" "- read_buffer_size" "$(printf "%.8f MB" $(echo "$mysql_data" | awk '{print $15}'))" "" "" ""
printf "| %-31s | %-23s | %-19s | %-16s | %-15s |\n" "- read_rnd_buffer_size" "$(printf "%.8f MB" $(echo "$mysql_data" | awk '{print $16}'))" "" "" ""
printf "| %-31s | %-23s | %-19s | %-16s | %-15s |\n" "- sort_buffer_size" "$(printf "%.8f MB" $(echo "$mysql_data" | awk '{print $17}'))" "" "" ""
printf "| %-31s | %-23s | %-19s | %-16s | %-15s |\n" "- thread_stack" "$(printf "%.8f MB" $(echo "$mysql_data" | awk '{print $18}'))" "" "" ""
printf "| %-31s | %-23s | %-19s | %-16s | %-15s |\n" "- net_buffer_length" "$(printf "%.8f MB" $(echo "$mysql_data" | awk '{print $19}'))" "" "" ""
echo "$line"

# Nhóm Cache Parameters
printf "| %-31s | %-23s | %-19s | %-16s | %-15s |\n" "Cache Parameters" "Value" "" "" ""
printf "| %-31s | %-23s | %-19s | %-16s | %-15s |\n" "- thread_cache_size" "" "" "$(echo "$mysql_data" | awk '{print $20}')" ""
printf "| %-31s | %-23s | %-19s | %-16s | %-15s |\n" "- table_open_cache" "" "" "$(echo "$mysql_data" | awk '{print $21}')" ""
printf "| %-31s | %-23s | %-19s | %-16s | %-15s |\n" "- table_definition_cache" "" "" "$(echo "$mysql_data" | awk '{print $22}')" ""
printf "| %-31s | %-23s | %-19s | %-16s | %-15s |\n" "- performance_schema_max_table_instances" "" "" "$(echo "$mysql_data" | awk '{print $23}')" ""
echo "$line"

# Nhóm Slave Replication
printf "| %-31s | %-23s | %-19s | %-16s | %-15s |\n" "Slave Replication" "Value (MB)" "slave_parallel_threads" "$(echo "$mysql_data" | awk '{print $24}')" ""
printf "| %-31s | %-23s | %-19s | %-16s | %-15s |\n" "- slave_parallel_max_queued" "$(printf "%.8f MB" $(echo "$mysql_data" | awk '{print $25}'))" "" "" ""
echo "$line"

# Nhóm Open Files
printf "| %-31s | %-23s | %-19s | %-16s | %-15s |\n" "Open Files" "Value" "open_files_limit" "$(echo "$mysql_data" | awk '{print $26}')" ""
printf "| %-31s | %-23s | %-19s | %-16s | %-15s |\n" "- max_connect_errors" "" "" "$(echo "$mysql_data" | awk '{print $12}')" ""
echo "$line"

# Nhóm Timeout Parameters
printf "| %-31s | %-23s | %-19s | %-16s | %-15s |\n" "Timeout Parameters" "Value (seconds)" "" "" ""
printf "| %-31s | %-23s | %-19s | %-16s | %-15s |\n" "- wait_timeout" "" "" "$(echo "$mysql_data" | awk '{print $27}') s" ""
printf "| %-31s | %-23s | %-19s | %-16s | %-15s |\n" "- interactive_timeout" "" "" "$(echo "$mysql_data" | awk '{print $28}') s" ""
printf "| %-31s | %-23s | %-19s | %-16s | %-15s |\n" "- net_read_timeout" "" "" "$(echo "$mysql_data" | awk '{print $29}') s" ""
printf "| %-31s | %-23s | %-19s | %-16s | %-15s |\n" "- net_write_timeout" "" "" "$(echo "$mysql_data" | awk '{print $30}') s" ""
printf "| %-31s | %-23s | %-19s | %-16s | %-15s |\n" "- innodb_lock_wait_timeout" "" "" "$(echo "$mysql_data" | awk '{print $31}') s" ""
echo "$line"

# Nhóm InnoDB Parameters
printf "| %-31s | %-23s | %-19s | %-16s | %-15s |\n" "InnoDB Parameters" "Value" "" "" ""
printf "| %-31s | %-23s | %-19s | %-16s | %-15s |\n" "- innodb_flush_log_at_trx_commit" "" "" "$(echo "$mysql_data" | awk '{print $32}')" ""
printf "| %-31s | %-23s | %-19s | %-16s | %-15s |\n" "- innodb_max_dirty_pages_pct" "" "" "$(echo "$mysql_data" | awk '{print $33}')" ""
printf "| %-31s | %-23s | %-19s | %-16s | %-15s |\n" "- innodb_read_io_threads" "" "" "$(echo "$mysql_data" | awk '{print $34}')" ""
printf "| %-31s | %-23s | %-19s | %-16s | %-15s |\n" "- innodb_write_io_threads" "" "" "$(echo "$mysql_data" | awk '{print $35}')" ""
echo "$line"

# Tổng bộ nhớ
printf "| %-31s | %-23s | %-19s | %-16s | %-15s |\n" "Total Memory (GB)" "" "" "" "$(echo "$mysql_data" | awk '{print $36}')"
echo "$line"
