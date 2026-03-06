file_path = "./logs_server.txt"
error_count = {}

try:
    with open(file_path, 'r', encoding='utf-8') as file:
        # Read all lines one by one to avoid memory issues
        for line in file:
            parts = line.strip().split() # Should split the line by spaces
            
            # Guarantees that the line is not empty and checks if the last item is '500'
            if parts and parts[-1] == "500":
                ip_error = parts[0]
                
                # .get() tries to get the current value. If the IP doesn't exist, it returns 0.
                error_count[ip_error] = error_count.get(ip_error, 0) + 1

    print(error_count)

except FileNotFoundError:
    print(f"Error: The file '{file_path}' was not found.")