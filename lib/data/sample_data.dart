import '../models/faculty.dart';
import '../models/student.dart';

List<Faculty> sampleFaculty() => [
      Faculty(
        id: 'f1',
        name: 'Dr. Elena Marquez',
        title: 'Associate Professor',
        department: 'College of Computing',
        specialization: 'Machine Learning & Data Science',
        researchInterests:
            'machine learning data science predictive analytics neural networks deep learning classification data mining python tensorflow',
        keywords: ['machine learning', 'deep learning', 'neural networks', 'data mining', 'predictive analytics', 'classification'],
        maxAdviserLoad: 3, maxPanelLoad: 5, currentAdviserLoad: 1, currentPanelLoad: 2,
      ),
      Faculty(
        id: 'f2',
        name: 'Engr. Rafael Santos',
        title: 'Assistant Professor',
        department: 'College of Computing',
        specialization: 'Web & Mobile Development',
        researchInterests:
            'web development mobile applications react javascript node frontend backend api responsive progressive web apps user interface',
        keywords: ['web development', 'mobile apps', 'react', 'javascript', 'api', 'responsive design'],
        maxAdviserLoad: 4, maxPanelLoad: 6, currentAdviserLoad: 2, currentPanelLoad: 3,
      ),
      Faculty(
        id: 'f3',
        name: 'Dr. Carmela Reyes',
        title: 'Professor',
        department: 'College of Computing',
        specialization: 'Information Security',
        researchInterests:
            'cybersecurity network security cryptography encryption penetration testing vulnerability assessment intrusion detection firewall information assurance blockchain',
        keywords: ['cybersecurity', 'network security', 'cryptography', 'intrusion detection', 'encryption', 'blockchain'],
        maxAdviserLoad: 3, maxPanelLoad: 5, currentAdviserLoad: 1, currentPanelLoad: 1,
      ),
      Faculty(
        id: 'f4',
        name: 'Prof. Daniel Cruz',
        title: 'Assistant Professor',
        department: 'College of Computing',
        specialization: 'IoT & Embedded Systems',
        researchInterests:
            'internet of things embedded systems arduino raspberry sensors microcontrollers automation hardware monitoring smart devices',
        keywords: ['iot', 'embedded systems', 'arduino', 'sensors', 'automation', 'monitoring'],
        maxAdviserLoad: 3, maxPanelLoad: 4, currentAdviserLoad: 0, currentPanelLoad: 2,
      ),
      Faculty(
        id: 'f5',
        name: 'Dr. Sophia Lim',
        title: 'Associate Professor',
        department: 'College of Computing',
        specialization: 'Database & Information Systems',
        researchInterests:
            'database management systems sql data warehousing information systems business intelligence query optimization mysql analytics enterprise',
        keywords: ['database', 'data warehousing', 'sql', 'business intelligence', 'information systems', 'analytics'],
        maxAdviserLoad: 4, maxPanelLoad: 5, currentAdviserLoad: 2, currentPanelLoad: 4,
      ),
      Faculty(
        id: 'f6',
        name: 'Engr. Marcus Tan',
        title: 'Assistant Professor',
        department: 'College of Computing',
        specialization: 'Cloud Computing & Networking',
        researchInterests:
            'cloud computing networking aws azure devops virtualization distributed systems server administration docker kubernetes scalability',
        keywords: ['cloud computing', 'networking', 'devops', 'virtualization', 'distributed systems', 'docker'],
        maxAdviserLoad: 3, maxPanelLoad: 5, currentAdviserLoad: 1, currentPanelLoad: 1,
      ),
    ];

List<Student> sampleStudents() => [
      Student(
        id: 's1', name: 'Maria Lopez', program: 'BSIT', year: '4th Year',
        topic: 'An Intelligent Crop Disease Detection System Using Convolutional Neural Networks and Deep Learning',
        researchArea: 'Machine Learning', methodology: 'Experimental / Model Training',
        keywords: ['deep learning', 'neural networks', 'image classification', 'predictive analytics'],
        submitted: true,
      ),
      Student(
        id: 's2', name: 'John Dela Cruz', program: 'BSIT', year: '4th Year',
        topic: 'Development of a Progressive Web Application for Campus Event Management',
        researchArea: 'Web Development', methodology: 'Agile / Developmental',
        keywords: ['web development', 'react', 'javascript', 'responsive design'],
        submitted: true,
      ),
      Student(
        id: 's3', name: 'Angela Reyes', program: 'BSIT', year: '4th Year',
        topic: 'A Network Intrusion Detection Framework Using Anomaly-Based Security Analysis',
        researchArea: 'Information Security', methodology: 'Experimental',
        keywords: ['cybersecurity', 'network security', 'intrusion detection', 'encryption'],
        submitted: true,
      ),
      Student(
        id: 's4', name: 'Kevin Tan', program: 'BSIT', year: '4th Year',
        topic: 'Smart Greenhouse Monitoring System Using IoT Sensors and Arduino Microcontrollers',
        researchArea: 'Internet of Things', methodology: 'Developmental / Prototyping',
        keywords: ['iot', 'sensors', 'arduino', 'monitoring', 'automation'],
        submitted: true,
      ),
      Student(
        id: 's5', name: 'Patricia Gomez', program: 'BSIT', year: '4th Year',
        topic: 'A Data Warehouse and Business Intelligence Dashboard for Enrollment Analytics',
        researchArea: 'Information Systems', methodology: 'Developmental',
        keywords: ['database', 'data warehousing', 'business intelligence', 'sql', 'analytics'],
        submitted: true,
      ),
    ];
