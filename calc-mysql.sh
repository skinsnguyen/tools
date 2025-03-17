#
#17/03/2025
#

SELECT (
           (
               @@binlog_file_cache_size +
               @@innodb_buffer_pool_size +
               @@innodb_log_buffer_size +
               @@key_buffer_size +
               @@query_cache_size +
               ( @@max_connections *
                   ( @@binlog_cache_size +
                     @@binlog_stmt_cache_size +
                     @@bulk_insert_buffer_size +
                     @@join_buffer_size +
                     @@max_allowed_packet +
                     @@read_buffer_size +
                     @@read_rnd_buffer_size +
                     @@sort_buffer_size +
                     @@thread_stack +
                     @@tmp_table_size
                   )
               ) +
               ( @@slave_parallel_threads * 
                 ( @@slave_parallel_max_queued )
               ) +
               ( @@open_files_limit * 1024 )
           ) / 1024 / 1024 / 1024) AS max_memory_GB;
