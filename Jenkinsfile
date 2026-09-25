pipeline {
    agent any

    environment {
        WAR_FILE = 'target/linkpay.war'        // WAR file path
        MAVEN_TOOL = 'maven3.9.16'             // Maven tool name
        SLACK_CHANNEL = '#amazon'           // Your Slack channel
    }

    stages {
        // Stage 1: Git Build
        stage('1. Git Build') {
            steps {
                git branch: 'main', credentialsId: 'amazon', url: 'https://github.com/harunch13/Amazon-project.git'
            }
        }

        // Stage 2: Maven Build
        stage('2. Maven Build') {
            steps {
                withMaven(maven: 'maven3.9.16') {
                    sh "mvn clean package -Dmaven.test.skip=true"
                }
            }
        }

        // Stage 3: SonarQube Analysis (optional)
        stage('3. SonarQube Analysis') {
            steps {
                echo "⏩ Skipping SonarQube analysis for now..."
            }
        }

        // Stage 4: Deploy to Nexus (optional)
        stage('4. Deploy to Nexus') {
            steps {
                echo "⏩ Skipping Nexus deployment for now..."
            }
        }

        // Stage 5: Deploy to Test Tomcat
        stage('5. Deploy to Test Tomcat') {
            steps {
                echo "🚀 Deploying WAR to TEST Tomcat server..."
                deploy adapters: [
                    tomcat9(
                        credentialsId: 'amazon-deploy',
                        url: 'http://tomcat:8080/'
                    )
                ],
                contextPath: 'linkpay-test',
                war: 'target/linkpay.war'
            }
        }

        // Stage 6: Manual Approval Before Production
        stage('6. Manual Approval Before Production') {
            steps {
                script {
                    // 🟡 Notify Slack before approval
                    slackSend(
                        channel: "${SLACK_CHANNEL}",
                        message: "🟡 *AWAITING APPROVAL:* ${env.JOB_NAME} #${env.BUILD_NUMBER} — Waiting for manual approval to deploy to *PRODUCTION*.",
                        color: '#e6c300'
                    )

                    // 🕒 Wait for manual approval (10 min timeout)
                    timeout(time: 10, unit: 'MINUTES') {
                        input message: "✅ Approve deployment to PRODUCTION Tomcat?"
                    }

                    // ✅ Notify Slack after approval
                    slackSend(
                        channel: "${SLACK_CHANNEL}",
                        message: "🟢 *APPROVED:* ${env.JOB_NAME} #${env.BUILD_NUMBER} — Proceeding with *PRODUCTION* deployment.",
                        color: 'good'
                    )
                }
            }
        }

        // Stage 7: Deploy to Production Tomcat
        stage('7. Deploy to Production Tomcat') {
            steps {
                echo "🚀 Deploying WAR to PRODUCTION Tomcat server..."
                deploy adapters: [
                    tomcat9(
                        credentialsId: 'amazon-deploy',
                        url: 'http://tomcat:8080/'
                    )
                ],
                contextPath: 'linkpay',
                war: 'target/linkpay.war'
            }
        }
    }

    // 🟩 Slack Notifications
    post {
        success {
            slackSend(
                channel: "${SLACK_CHANNEL}",
                message: "✅ *SUCCESS:* ${env.JOB_NAME} #${env.BUILD_NUMBER} — Deployment completed successfully!",
                color: 'good'
            )
        }
        failure {
            slackSend(
                channel: "${SLACK_CHANNEL}",
                message: "❌ *FAILED:* ${env.JOB_NAME} #${env.BUILD_NUMBER} — Check Jenkins logs for details.",
                color: 'danger'
            )
        }
        unstable {
            slackSend(
                channel: "${SLACK_CHANNEL}",
                message: "⚠️ *UNSTABLE:* ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                color: 'warning'
            )
        }
    }
}
