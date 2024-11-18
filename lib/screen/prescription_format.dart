const prescriptionFormat = """
<div style="padding: 16px; font-family: Arial, sans-serif; max-width: 100%; box-sizing: border-box;">
  <!-- Header Section -->
  <h2 style="text-align: center; font-size: 18px; margin-bottom: 16px;">Prescription</h2>

  <!-- Doctor Details -->
  <div style="display: flex; flex-direction: column; gap: 8px; margin-bottom: 16px;">
    <div style="border: 1px dashed #ccc; padding: 8px; width: 100%;">
      <p style="margin: 0;">
        <strong>Dr. Hasan Shahrear</strong><br>
        DVM (CVASU) MS in Pathology (BAU)<br>
        PGT in Clinics (TANUVAS, INDIA)<br>
        Kanchijhuli, Mymensingh<br>
        Mobile: 01711-020304, 01932-123987<br>
        E-mail: hasansharear@agro.net
      </p>
    </div>
  </div>

  <!-- Farm Owner and Animal Info -->
  <div style="border: 1px solid #ccc; padding: 8px; margin-bottom: 16px; width: 100%;">
    <div style="display: flex; justify-content: space-between; flex-wrap: wrap;">
      <span>Name :</span>
    </div>
    <div style="display: flex; justify-content: space-between; flex-wrap: wrap;">
      <span>Age :</span>
    </div>
    <div style="margin-top: 8px; text-align: center;">Info</div>
  </div>

<!-- Sections -->
<div style="display: flex; flex-wrap: wrap; gap: 16px; justify-content: space-between;">
  <!-- Owner's Complaint and Details -->
  <div style="flex: 1; min-width: calc(50% - 16px); border: 1px solid #ccc; padding: 8px; box-sizing: border-box;">
    <h3 style="margin: 0; font-size: 14px;">Owner's Complaint</h3>
    <p style="margin: 4px 0 0; word-break: break-word; overflow-wrap: break-word;">Demo Complaint that might be very long and take up a lot of space if not properly wrapped.</p>
    <p style="margin: 4px 0 0; color: #666; word-break: break-word; overflow-wrap: break-word;">Demo Remarks with a long text that needs proper wrapping.</p>
    <h3 style="margin: 0; font-size: 14px;">Clinical Findings</h3>
    <p style="margin: 4px 0 0; word-break: break-word; overflow-wrap: break-word;">Demo Findings</p>
    <p style="margin: 4px 0 0; color: #666; word-break: break-word; overflow-wrap: break-word;">Demo Remarks</p>
    <h3 style="margin: 0; font-size: 14px;">Postmortem Findings</h3>
    <p style="margin: 4px 0 0; word-break: break-word; overflow-wrap: break-word;">Demo Findings</p>
    <p style="margin: 4px 0 0; color: #666; word-break: break-word; overflow-wrap: break-word;">Demo Remarks</p>
    <h3 style="margin: 0; font-size: 14px;">Diagnosis</h3>
    <p style="margin: 4px 0 0; word-break: break-word; overflow-wrap: break-word;">Diagnosis text that could be extremely long if it contains detailed notes.</p>
  </div>

  <!-- Rx and Advice -->
  <div style="flex: 1; min-width: calc(50% - 16px); border: 1px solid #ccc; padding: 8px; box-sizing: border-box;">
    <h3 style="margin: 0; font-size: 14px;">Rx</h3>
    <p style="margin: 4px 0 0; word-break: break-word; overflow-wrap: break-word;">Demo Medicine that has a lot of details to mention if not properly handled.</p>
    <p style="margin: 4px 0 0; color: #666; word-break: break-word; overflow-wrap: break-word;">Demo Remarks</p>
    <h3 style="margin: 0; font-size: 14px;">Advice</h3>
    <p style="margin: 4px 0 0; word-break: break-word; overflow-wrap: break-word;">Demo Advice that might take up multiple lines and should be wrapped properly.</p>
    <p style="margin: 4px 0 0; color: #666; word-break: break-word; overflow-wrap: break-word;">Demo Remarks</p>
  </div>
</div>

<!-- Footer Buttons -->
<div style="display: flex; justify-content: space-between; gap: 16px; margin-top: 16px;">
  <button style="flex: 1; padding: 8px; border: 1px solid #ccc; background: #fff; cursor: pointer;">👁 Reset</button>
  <button style="flex: 1; padding: 8px; border: 1px solid #28a745; background: #28a745; color: #fff; cursor: pointer;">💾 Save</button>
</div>
</div>
""";
