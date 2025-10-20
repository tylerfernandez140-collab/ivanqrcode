import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        child: Html(
          data: '''
            <style>
              [data-custom-class='body'], [data-custom-class='body'] * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: Arial, sans-serif;
              }
              [data-custom-class='body'] h1 {
                color: #2c3e50;
                margin: 20px 0;
                font-size: 24px;
              }
              [data-custom-class='body'] p {
                color: #34495e;
                line-height: 1.6;
                margin: 15px 0;
              }
            </style>
            <div data-custom-class='body'>
              <h1>Privacy Policy</h1>
              <p>This Privacy Policy governs the manner in which Quickode Scanner collects, uses, maintains, and discloses information collected from users (each, a "User") of the Quickode Scanner mobile application ("App"). This privacy policy applies to the App and all products and services offered by Quickode Scanner.</p>

              <h2>Personal identification information</h2>
              <p>We may collect personal identification information from Users in a variety of ways, including, but not limited to, when Users visit our App, register on the App, and in connection with other activities, services, features or resources we make available on our App. Users may be asked for, as appropriate, name, email address. Users may, however, visit our App anonymously. We will collect personal identification information from Users only if they voluntarily submit such information to us. Users can always refuse to supply personally identification information, except that it may prevent them from engaging in certain App related activities.</p>

              <h2>Non-personal identification information</h2>
              <p>We may collect non-personal identification information about Users whenever they interact with our App. Non-personal identification information may include the browser name, the type of computer and technical information about Users means of connection to our App, such as the operating system and the Internet service providers utilized and other similar information.</p>

              <h2>How we use collected information</h2>
              <p>Quickode Scanner may collect and use Users personal information for the following purposes:</p>
              <ul>
                <li><i>To improve customer service</i><br/>
                  Information you provide helps us respond to your customer service requests and support needs more efficiently.</li>
                <li><i>To personalize user experience</i><br/>
                  We may use information in the aggregate to understand how our Users as a group use the services and resources provided on our App.</li>
                <li><i>To improve our App</i><br/>
                  We may use feedback you provide to improve our products and services.</li>
                <li><i>To send periodic emails</i><br/>
                  We may use the email address to send User information and updates pertaining to their order. It may also be used to respond to their inquiries, questions, and/or other requests.</li>
              </ul>

              <h2>How we protect your information</h2>
              <p>We adopt appropriate data collection, storage and processing practices and security measures to protect against unauthorized access, alteration, disclosure or destruction of your personal information, username, password, transaction information and data stored on our App.</p>

              <h2>Sharing your personal information</h2>
              <p>We do not sell, trade, or rent Users personal identification information to others. We may share generic aggregated demographic information not linked to any personal identification information regarding visitors and users with our business partners, trusted affiliates and advertisers for the purposes outlined above.</p>

              <h2>Third party websites</h2>
              <p>Users may find advertising or other content on our App that link to the sites and services of our partners, suppliers, advertisers, sponsors, licensors and other third parties. We do not control the content or links that appear on these sites and are not responsible for the practices employed by websites linked to or from our App. In addition, these sites or services, including their content and links, may be constantly changing. These sites and services may have their own privacy policies and customer service policies. Browsing and interaction on any other website, including websites which have a link to our App, is subject to that website's own terms and policies.</p>

              <h2>Advertising</h2>
              <p>Ads appearing on our App may be delivered to Users by advertising partners, who may set cookies. These cookies allow the ad server to recognize your computer each time they send you an online advertisement to compile non personal identification information about you or others who use your computer. This information allows ad networks to, among other things, deliver targeted advertisements that they believe will be of most interest to you. This privacy policy does not cover the use of cookies by any advertisers.</p>

              <h2>Google AdMob</h2>
              <p>Some of the ads may be served by Google AdMob. Google's use of the DART cookie enables it to serve ads to Users based on their visit to our App and other sites on the Internet. DART uses "non personally identifiable information" and does NOT track personal information about you, such as your name, email address, etc. You may opt out of the use of the DART cookie by visiting the Google ad and content network privacy policy at <a href="http://www.google.com/privacy_ads.html">http://www.google.com/privacy_ads.html</a></p>

              <h2>Changes to this privacy policy</h2>
              <p>Quickode Scanner has the discretion to update this privacy policy at any time. When we do, we will revise the updated date at the bottom of this page. We encourage Users to frequently check this page for any changes to stay informed about how we are helping to protect the personal information we collect. You acknowledge and agree that it is your responsibility to review this privacy policy periodically and become aware of modifications.</p>

              <h2>Your acceptance of these terms</h2>
              <p>By using this App, you signify your acceptance of this policy. If you do not agree to this policy, please do not use our App. Your continued use of the App following the posting of changes to this policy will be deemed your acceptance of those changes.</p>

              <h2>Contacting us</h2>
              <p>If you have any questions about this Privacy Policy, the practices of this App, or your dealings with this App, please contact us at:</p>
              <p>Quickode Scanner<br/>
                ivancreates2025@gmail.com</p>
              <p>This document was last updated on October 26, 2023</p>
            </div>
          ''',
        ),
      ),
    );
  }
}