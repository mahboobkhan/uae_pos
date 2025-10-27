# Fix for Download Issue on Web

## Problem
Downloads are not working on web platform due to CORS (Cross-Origin Resource Sharing) restrictions.

## Solution: Add CORS Headers to Your Server

Add these headers to your server configuration:

### Option 1: PHP (.htaccess)
Add to your `.htaccess` file:
```apache
<IfModule mod_headers.c>
    Header set Access-Control-Allow-Origin "*"
    Header set Access-Control-Allow-Methods "GET, POST, OPTIONS"
    Header set Access-Control-Allow-Headers "Content-Type"
</IfModule>
```

### Option 2: PHP (in your document serving file)
Add to your PHP files that serve documents:
```php
<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

// Force download
header("Content-Disposition: attachment; filename=\"" . basename($file) . "\"");
header("Content-Type: application/octet-stream");
readfile($file);
?>
```

### Option 3: If using a web server (Apache/Nginx)
Add CORS headers in server configuration.

## After adding CORS headers:
1. The downloads will work properly
2. Files will download instead of opening in new tabs
3. Works for both web and mobile platforms

## Current URLs being accessed:
- http://abcwebservices.com/api/documents_files/office_payment/
- http://abcwebservices.com/documents/office_payment/
- http://abcwebservices.com/api/documents_files/client/
- http://abcwebservices.com/api/documents_files/client_payment/
- http://abcwebservices.com/documents/

Make sure all these paths allow CORS.

