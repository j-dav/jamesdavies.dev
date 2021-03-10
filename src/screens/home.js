import styled from 'styled-components';
import { withRouter } from 'react-router';

const Container = styled.div`
  display: flex;
`;

const Home = () => {
  return (
    <Container>
      <p>Hello</p>
    </Container>
  );
};

export default withRouter(Home);