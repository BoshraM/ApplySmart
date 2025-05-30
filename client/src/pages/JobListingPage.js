import React, { useEffect, useState } from "react";
import JobModal from "../components/JobModal";
import LoadingCircle from "../components/LoadingCircle";
import Top from "../components/Top";
import { Button, Space, Flex, List, Typography , Grid} from "antd";
import { LinkOutlined } from "@ant-design/icons";
import { Content } from "antd/es/layout/layout";
const { useBreakpoint } = Grid;

const { Title, Paragraph, Link: AntdLink } = Typography; // Destructuring Link as AntdLink

function JobListingPage({
  handleFileUpload,
  handleTextSubmit,
  generateJobList,
  sendJobDescriptionToServer,
  sendJobDForView,
  jobList,
  fullJobDescription,
  loading,
}) {
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [selectedJobUrl, setSelectedJobUrl] = useState("");
  const breakpoints = useBreakpoint();

  const openModal = () => {
    setIsModalOpen(true);
  };

  const closeModal = () => {
    setIsModalOpen(false);
  };

  const handleViewButtonClick = (redirectUrl) => {
    sendJobDForView(redirectUrl);
    openModal();
    setSelectedJobUrl(redirectUrl);
  };

  const tailorCV = () => {
    sendJobDescriptionToServer(selectedJobUrl);
  };

  useEffect(() => {
    const fetchData = async () => {
      try {
        setIsLoading(true);
        await generateJobList();
      } catch (error) {
        console.error("Error fetching job data:", error);
      } finally {
        setIsLoading(false);
      }
    };

    fetchData();
  }, []);

  return (
      <Flex
        gap="56px"
        style={{
          background: "var(--white, #FFF)",
          padding:breakpoints.xs ? "30px 15px" : "44px 68px" ,
          height:"100%"
        }}
        vertical
      >
        <Top
          handleFileUpload={handleFileUpload}
          handleTextSubmit={handleTextSubmit}
        />
        {isLoading ? (
          <LoadingCircle />
        ) : jobList.length > 0 ? (
          <Flex gap="32px" vertical>
            <Space>
              <Title level={3} size={"medium"}>
                Recommended jobs
              </Title>
            </Space>
            <List
              itemLayout="horizantal"
              dataSource={jobList}
              pagination={{
                onChange: (page) => {
                  console.log(page);
                },
                pageSize: 5,
                align: "center",
                position: "bottom",
              }}
              renderItem={(item, index) => (
                <List.Item>
                  <Content>
                    <Flex
                      gap="16px"
                      style={{ position: "relative" , flexDirection: !breakpoints.md && "column"}}
                      align="flex-start"
                    >
                      <Title
                        level={4}
                        style={{
                          flex: "1",
                          alignItems: "flex-start",
                          margin: "0",
                          marginTop: 10,
                        }}
                      >
                        {item.title}
                      </Title>
                      <Flex
                        gap={"24px"}
                        align="flex-start"
                        style={{ position: "relative", display: "inline-flex", flexDirection: breakpoints.xs && "column"}}
                      >
                        <Button
                          onClick={() =>
                            handleViewButtonClick(item.redirect_url)
                          }
                        >
                          Quick view
                        </Button>
                        <Button
                          type="primary"
                          onClick={() =>
                            sendJobDescriptionToServer(item.redirect_url)
                          }
                        >
                          Tailor CV for this job
                        </Button>
                      </Flex>
                    </Flex>
                    <Title level={5}>Salary:{item.salary_min}</Title>
                    <Paragraph>{item.description}</Paragraph>
                    <AntdLink
                      href={item.redirect_url}
                      target="_blank"
                      rel="noopener noreferrer"
                    >
                      <LinkOutlined /> View job (open a new tab)
                    </AntdLink>
                    <Typography.Text type="secondary">
                      {" "}
                      You will be redirected to Adzuna, a job ads website.
                    </Typography.Text>
                  </Content>
                </List.Item>
              )}
            />
          </Flex>
        ) : (
          <p>No jobs available.</p>
        )}
        <JobModal
          isOpen={isModalOpen}
          onClose={closeModal}
          fullJobDescription={fullJobDescription}
          tailorCV={tailorCV}
          showTailorCVButton={selectedJobUrl !== ""} // Pass the condition to show the button
        />
         {loading ? <LoadingCircle /> : ""}
      </Flex>
     

  );
}

export default JobListingPage;
