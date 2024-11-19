String prescriptionInfoTemplete = """

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Prescription Template</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
        }

        .container {
            margin: 20px;
            padding: 10px;
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 10px;
        }

        .header {
            background-color: #c5b3f7;
            color: white;
            padding: 15px;
            font-size: 24px;
            font-weight: bold;
        }

        .row {
            display: flex;
            justify-content: space-between;
            margin: 20px 0;
        }

        .box {
            flex: 1;
            border: 1px solid #ddd;
            margin: 0 10px;
            padding: 10px;
            border-radius: 8px;
            background-color: #fefefe;
        }

        .box p {
            margin: 5px 0;
        }

        .middle-box {
            border: 1px solid #ddd;
            padding: 10px;
            background-color: #fcf8f5;
            border-radius: 8px;
            text-align: left;
        }

        .footer {
            display: flex;
            justify-content: space-between;
            padding: 10px;
            border-top: 2px solid #ddd;
            margin-top: 20px;
            color: #333;
            background-color: #fafafa;
        }

        .footer .box {
            flex: 1;
            margin: 0 5px;
        }

        .editable {
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">Prescription</div>
        <div class="row">
            <!-- First Left Box -->
            <div class="box">
                <p><span class="editable" id="doctor-left-name">Dr. Hasan Shahriar</span></p>
                <p><span class="editable" id="doctor-left-title">Chief Cardiologist, Dhaka Medical (MBBS), FCPS</span></p>
                <p>Cell: <span class="editable" id="doctor-left-cell">+8801700000000</span></p>
                <p>Address:</p>
                <p><span class="editable" id="doctor-left-address">203, Second Floor, K/49, Krishna Nagar...</span></p>
            </div>
            <!-- Second Right Box -->
            <div class="box">
                <p><span class="editable" id="doctor-right-name">Dr. Hasan Shahriar</span></p>
                <p><span class="editable" id="doctor-right-title">Chief Cardiologist, Dhaka Medical (MBBS), FCPS</span></p>
                <p>Cell: <span class="editable" id="doctor-right-cell">+8801700000000</span></p>
                <p>Address:</p>
                <p><span class="editable" id="doctor-right-address">203, Second Floor, K/49, Krishna Nagar...</span></p>
            </div>
        </div>
        <div class="middle-box">
            <p>Name: <span class="editable" id="patient-name">Abul Hasan</span></p>
            <p>Age: <span class="editable" id="patient-age">50y</span></p>
        </div>
        <div class="footer">
            <!-- Footer Section -->
            <div class="box">
                <p><strong>Owners Complaint</strong></p>
                <p>Complaints</p>
                <p>Remarks</p>
            </div>
            <div class="box">
                <p><strong>Rx</strong></p>
                <p>Complaints</p>
                <p>Remarks</p>
            </div>
        </div>
    </div>
</body>
</html>



""";
